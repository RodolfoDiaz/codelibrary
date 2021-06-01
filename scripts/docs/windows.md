# Microsoft Windows configuration

[Windows Environment Variables](https://ss64.com/nt/syntax-variables.html) are mainly used within batch files, they can be created, modified and deleted for a session using the SET command. To make permanent changes, use SETX.

## System Environment Variables

 | ENV VARIABLE	| DESCRIPTION | 
 | ------------ | ----------- |
 | %ALLUSERSPROFILE%	| C:\ProgramData | 
 | %APPDATA%	 | C:\Users\\`{username}`\AppData\Roaming  %USERPROFILE%\AppData\Roaming | 
 | %COMMONPROGRAMFILES%	 | C:\Program Files\Common Files | 
 | %COMMONPROGRAMFILES(x86)%	 | C:\Program Files (x86)\Common Files | 
 | %CommonProgramW6432%	 | C:\Program Files\Common Files | 
 | %COMSPEC%	 | C:\Windows\System32\cmd.exe | 
 | %HOMEDRIVE%	 | C:\ | 
 | %HOMEPATH%	 | \Users\\`{username}` | 
 | %LOCALAPPDATA%	 | C:\Users\\`{username}`\AppData\Local | 
 | %LOGONSERVER%	 | \\domain_logon_server | 
 | %PATH%	 | C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem | 
 | %PathExt%	 | .com;.exe;.bat;.cmd;.vbs;.vbe;.js;.jse;.wsf;.wsh;.msc | 
 | %PROGRAMDATA%	 | C:\ProgramData | 
 | %PROGRAMFILES%	 | C:\Program Files | 
 | %ProgramW6432%	 | C:\Program Files | 
 | %PROGRAMFILES(X86)%	 | C:\Program Files (x86) | 
 | %PROMPT%	 | $P$G | 
 | %SystemDrive%	 | C: | 
 | %SystemRoot%	 | C:\Windows | 
 | %TEMP%	 | C:\Users\\`{username}`\AppData\Local\Temp | 
 | %TMP%	 | C:\Users\\`{username}`\AppData\Local\Temp | 
 | %USERDOMAIN%	 | AD domain associated with current user. | 
 | %USERDOMAIN_ROAMINGPROFILE%	 | Userdomain associated with roaming profile. | 
 | %USERNAME%	 | {`username`} | 
 | %USERPROFILE%	 | C:\Users\\`{username}` | 
 | %WINDIR%	 | C:\Windows | 
 | %PUBLIC%	 | C:\Users\Public | 
 | %PSModulePath%	 | %SystemRoot%\system32\WindowsPowerShell\v1.0\Modules\ | 
 | %OneDrive%	 | C:\Users\\`{username}`\OneDrive | 
 | %DriverData%	 | C:\Windows\System32\Drivers\DriverData | 
 | %CD%	 | Outputs current directory path. (Command Prompt.) | 
 | %CMDCMDLINE%	 | Outputs command line used to launch current Command  | Prompt session. (Command Prompt.)
 | %CMDEXTVERSION%	 | Outputs the number of current command processor  |extensions. (Command Prompt.) | 
 | %COMPUTERNAME%	 | Outputs the system name. | 
 | %DATE%	 | Outputs current date. (Command Prompt.) | 
 | %TIME%	 | Outputs time. (Command Prompt.) | 
 | %ERRORLEVEL%	 | Outputs the number of defining exit status of previous command. (Command Prompt.) | 
 | %PROCESSOR_IDENTIFIER%	 | Outputs processor identifier. | 
 | %PROCESSOR_LEVEL%	 | Outputs processor level. | 
 | %PROCESSOR_REVISION%	 | Outputs processor revision. | 
 | %NUMBER_OF_PROCESSORS%	 | Outputs the number of physical and virtual cores. | 
 | %RANDOM%	 | Outputs random number from 0 through 32767. | 
 | %OS%	 | Windows_NT | 

****

## File path to System Folders


 | PATH	| DESCRIPTION | 
 | ---- | ----------- |
 | %UserProfile%\Desktop | Desktop folder for current user |
 | %AppData%\Microsoft\Windows\SendTo | Send To folder for current user | 
 | %AppData%\Microsoft\Windows\Start Menu\Programs | Start Menu folder for current user | 
 | %ProgramData%\Microsoft\Windows\Start Menu\Programs | Start Menu folder for all users |
 | %USERPROFILE%\AppData\Local\Temp | C:\Users\\`{username}`\AppData\Local\Temp | 
 | %SystemRoot%\system\ | C:\Windows\System | 
 | %SystemRoot%\system32\ | C:\Windows\System32 | 
