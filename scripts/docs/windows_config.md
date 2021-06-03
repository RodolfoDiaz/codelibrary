# Microsoft Windows configuration

[Windows Environment Variables](https://ss64.com/nt/syntax-variables.html) are mainly used within batch files, they can be created, modified and deleted for a session using the SET command. To make permanent changes, use SETX.

## System Environment Variables

 | Environment Variable	| Description | 
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

****

## Power Settings

Add High Performance or Ultimate Performance Plan in Windows 10 Using the Powercfg Command.  The Ultimate Performace power plan is designed to give an extra boost to high-power systems (think workstations and servers) by optimizing the High-Performance power plan.

Open command line or PowerShell and enter the following command(s).

1. To add the High Performance plan:
```
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
```
2. If you need to add the Ultimate Performance plan:
```
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
```
3. Restart your PC.
4. Press Win+X. Select "Power Options".  As an aternative, hit Win+I, select System, select "Power Options".
5. Click on the "Additional Power Settings" link in the Related settings area, select the power plan option.

****

## Steps to fix duplicate drives in Windows 10 File Explorer

To fix the Duplicate drives problem in Windows 10 file explorer, you simply have to remove a key from the Registry. It is as simple as that. To do this, follow the simple steps given below.

1. Press the Win+X keys simultaneously and select Run from the options.
2. After opening the Run dialog box, type regedit and press Enter. It will prompt you to confirm the action. Click Yes and the Registry Editor will be opened.
3. Now follow this path in registry keys list on the left panel and Navigate to the DelegateFolders key.  
    ```
    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders
    ```
4. After navigating to the DelegateFolders key, there will be a sub-key named as 
    ```
    {F5FB2C77-0E2F-4A16-A381-3E560C68BC83}
    ```
5. Delete the {F5FB2C77-0E2F-4A16-A381-3E560C68BC83} key by right-clicking it and selecting the Delete option. Once this key is deleted, there won’t be any duplicate drive icons in Windows 10 File Explorer.

Note: If you’re running the 32-bit version of Windows 10, all is accomplished and you can relax. If you’re a 64-bit user, you will find that the duplicate drive icons are still present in some windows like Browse window or Save and Save As windows used by some 3rd party applications.

To identify your system type, right click This PC icon and then choose Properties. In the new System window you can determine whether it’s a 32 bit or 64 bit type of Windows.

To get rid of this, you need to remove one more key from the Registry. To do this:

1. Open Run dialog by pressing Win+R keys together.
2. After opening the Run dialog box, type regedit and press Enter. Next, confirm the action. Click Yes and it will open the Registry Editor.
3. Now follow this path on the list in the left-hand side and navigate to the DelegateFolders key. 
    ```
    HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders
    ```
4. Under the DelegateFolders key, delete {F5FB2C77-0E2F-4A16-A381-3E560C68BC83} key.
5. Restart your PC.

****

## How to rename the User folder in Windows 10?

### Option 1:

This can be done without folder renaming and messing with registry:

1. Create a local account with the user name you wish.
    * Local account creation is well hidden; here is how to find it:
    Settings > Accounts > Family & Other users > Other users > Add someone else to this PC > The person I want to add doesn't have an email address > Add a user without Microsoft account
2. Change account type to administrator (can skip if there is other administrator).
3. Remove original Microsoft linked account
4. Link local account to Microsoft account if you wish

### Option 2:

There is no need to create a new user account, so all the settings associated with the existing user profile are preserved. And the only registry change required is to edit a single string value (the one that tells Windows the path of the user profile folder):

1. Log in by using another administrative account.
    * Note You may need to create a new Administrative account at first.
2. Go to the C:\users\ folder and rename the subfolder with the original user name to the new user name.
3. Go to the registry and modify the registry value ProfileImagePath to the new path name.
    ```
    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\<User SID>\
    ```
4. Restart your PC.

The procedure quoted above was provided by Microsoft ([here](https://support.microsoft.com/en-gb/help/2454362/renaming-a-user-account-does-not-automatically-change-the-profile-path)) in relation to a perceived issue with Windows 7, and continues to work in Windows 10.
