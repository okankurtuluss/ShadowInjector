$buf = [Byte[]] @(
    # shellcode will be written here
)

$base64String = [System.Convert]::ToBase64String($buf)

Write-Output $base64String

