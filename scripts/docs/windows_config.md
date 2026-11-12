# Microsoft Windows Configuration

[Windows Environment Variables](https://ss64.com/nt/syntax-variables.html) are mainly used within batch files and scripts. They can be created, modified, and deleted for a single session using the `SET` command. To make permanent changes, use `SETX` (or the System Properties GUI).

## System Environment Variables

| Environment Variable          | Description / Default Value                                                                          |
| :---------------------------- | :--------------------------------------------------------------------------------------------------- |
| `%ALLUSERSPROFILE%`           | `C:\ProgramData`                                                                                     |
| `%APPDATA%`                   | `C:\Users\{username}\AppData\Roaming` (Equivalent to `%USERPROFILE%\AppData\Roaming`)                |
| `%COMMONPROGRAMFILES%`        | `C:\Program Files\Common Files`                                                                      |
| `%COMMONPROGRAMFILES(x86)%`   | `C:\Program Files (x86)\Common Files`                                                                |
| `%CommonProgramW6432%`        | `C:\Program Files\Common Files`                                                                      |
| `%COMSPEC%`                   | `C:\Windows\System32\cmd.exe`                                                                        |
| `%HOMEDRIVE%`                 | `C:`                                                                                                 |
| `%HOMEPATH%`                  | `\Users\{username}`                                                                                  |
| `%LOCALAPPDATA%`              | `C:\Users\{username}\AppData\Local`                                                                  |
| `%LOGONSERVER%`               | `\\domain_logon_server` (or `\\{COMPUTERNAME}` on local workgroups)                                  |
| `%PATH%`                      | `C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;...`                                        |
| `%PathExt%`                   | `.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC`                                              |
| `%PROGRAMDATA%`               | `C:\ProgramData`                                                                                     |
| `%PROGRAMFILES%`              | `C:\Program Files`                                                                                   |
| `%ProgramW6432%`              | `C:\Program Files`                                                                                   |
| `%PROGRAMFILES(X86)%`         | `C:\Program Files (x86)`                                                                             |
| `%PROMPT%`                    | `$P$G`                                                                                               |
| `%SystemDrive%`               | `C:`                                                                                                 |
| `%SystemRoot%`                | `C:\Windows`                                                                                         |
| `%TEMP%`                      | `C:\Users\{username}\AppData\Local\Temp`                                                             |
| `%TMP%`                       | `C:\Users\{username}\AppData\Local\Temp`                                                             |
| `%USERDOMAIN%`                | AD domain associated with the current user (or computer name if local).                              |
| `%USERDOMAIN_ROAMINGPROFILE%` | User domain associated with a roaming profile.                                                       |
| `%USERNAME%`                  | `{username}`                                                                                         |
| `%USERPROFILE%`               | `C:\Users\{username}`                                                                                |
| `%WINDIR%`                    | `C:\Windows`                                                                                         |
| `%PUBLIC%`                    | `C:\Users\Public`                                                                                    |
| `%PSModulePath%`              | `%SystemRoot%\system32\WindowsPowerShell\v1.0\Modules\`                                              |
| `%OneDrive%`                  | `C:\Users\{username}\OneDrive`                                                                       |
| `%DriverData%`                | `C:\Windows\System32\Drivers\DriverData`                                                             |
| `%CD%`                        | Outputs the current directory path. _(Command Prompt)_                                               |
| `%CMDCMDLINE%`                | Outputs the exact command line used to launch the current Command Prompt session. _(Command Prompt)_ |
| `%CMDEXTVERSION%`             | Outputs the version number of the current command processor extensions. _(Command Prompt)_           |
| `%COMPUTERNAME%`              | Outputs the system/host name.                                                                        |
| `%DATE%`                      | Outputs the current date. _(Command Prompt)_                                                         |
| `%TIME%`                      | Outputs the current time. _(Command Prompt)_                                                         |
| `%ERRORLEVEL%`                | Outputs the exit status code of the previous command. _(Command Prompt)_                             |
| `%PROCESSOR_IDENTIFIER%`      | Outputs the processor identifier string.                                                             |
| `%PROCESSOR_LEVEL%`           | Outputs the processor level/family.                                                                  |
| `%PROCESSOR_REVISION%`        | Outputs the processor revision number.                                                               |
| `%NUMBER_OF_PROCESSORS%`      | Outputs the total number of logical processors (physical and virtual cores).                         |
| `%RANDOM%`                    | Outputs a pseudo-random integer from `0` through `32767`.                                            |
| `%OS%`                        | `Windows_NT`                                                                                         |

---

## File Paths to System Folders

| Path                                                  | Description                                                       |
| :---------------------------------------------------- | :---------------------------------------------------------------- |
| `%UserProfile%\Desktop`                               | Desktop folder for the current user                               |
| `%AppData%\Microsoft\Windows\SendTo`                  | "Send To" context menu folder for the current user                |
| `%AppData%\Microsoft\Windows\Start Menu\Programs`     | Start Menu programs folder for the current user                   |
| `%ProgramData%\Microsoft\Windows\Start Menu\Programs` | Start Menu programs folder for all users                          |
| `%USERPROFILE%\AppData\Local\Temp`                    | Temporary files folder (`C:\Users\{username}\AppData\Local\Temp`) |
| `%SystemRoot%\system\`                                | `C:\Windows\System`                                               |
| `%SystemRoot%\system32\`                              | `C:\Windows\System32`                                             |

---

## Power Settings

Add the **High Performance** or **Ultimate Performance** power plan in Windows 10/11 using the `powercfg` command. The Ultimate Performance power plan is designed to give an extra boost to high-power systems (such as workstations and servers) by eliminating micro-latencies in the High Performance plan.

Open **Command Prompt** or **PowerShell** as Administrator and enter the desired command:

1. **To add the High Performance plan:**

   ```powershell
   powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
   ```

2. **To add the Ultimate Performance plan:**

   ```powershell
   powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
   ```

3. Restart your PC (optional, though sometimes required for the plan to appear).
4. Press `Win + X` and select **Power Options** (or press `Win + I` > **System** > **Power & battery**).
5. Open **Control Panel** > **Power Options** (or click **Additional power settings** in Windows 10) and select your newly added power plan.

---

## Steps to Fix Duplicate Drives in Windows File Explorer

To fix the duplicate external/removable drives issue in the Windows 10/11 File Explorer navigation pane, you can remove a specific `DelegateFolders` key from the Windows Registry.

> **Warning:** Always back up (export) your registry keys before deleting any entries in Registry Editor (`regedit`).

### Step 1: Remove the Primary Registry Key (32-bit & 64-bit Systems)

1. Press `Win + R` to open the **Run** dialog box.
2. Type `regedit` and press **Enter**. Click **Yes** when prompted by User Account Control (UAC).
3. Navigate to the following path in the left-hand pane:
   ```text
   HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders
   ```
4. Locate the sub-key named:
   ```text
   {F5FB2C77-0E2F-4A16-A381-3E560C68BC83}
   ```
5. Right-click `{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}`, select **Export** to save a backup, and then right-click and select **Delete**.

### Step 2: Remove the WOW6432Node Key (64-bit Systems Only)

If you are running a 64-bit version of Windows, duplicate drives may still appear inside 32-bit application **Open** or **Save As** dialog windows. To remove those as well:

1. In Registry Editor, navigate to:
   ```text
   HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders
   ```
2. Locate and delete the `{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}` sub-key.
3. Restart your PC (or restart **Windows Explorer** via Task Manager) for the changes to take full effect.

---

## How to Rename the User Profile Folder in Windows 10/11

### Option 1: Create a New Local Account (Recommended & Safest)

This approach avoids registry edits and prevents broken application paths:

1. Create a new local account with your desired folder name:
   - **Windows 10:** Go to **Settings** > **Accounts** > **Family & other users** > **Add someone else to this PC** > **I don't have this person's sign-in information** > **Add a user without a Microsoft account**.
   - **Windows 11:** Go to **Settings** > **Accounts** > **Other users** > **Add account** > **I don't have this person's sign-in information** > **Add a user without a Microsoft account**.
2. Change the new account type to **Administrator**.
3. Log into the new account, migrate your personal files from the old user folder, and remove the old account if desired.
4. Link the new local account to your Microsoft account via **Settings** > **Accounts** > **Your info**.

### Option 2: Rename the Existing Folder via Registry (Advanced)

> **Caution:** Renaming an active profile folder can break hardcoded application paths, shortcuts, and environment variables. Back up your data and create a System Restore point before proceeding.

1. Log in using a **different** administrative account (create a temporary one if needed).
2. Open File Explorer, navigate to `C:\Users\`, and rename the target user folder to the new name.
3. Press `Win + R`, type `regedit`, and press **Enter**.
4. Navigate to:
   ```text
   HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList
   ```
5. Click through the `S-1-5-21-...` sub-keys until you find the one whose `ProfileImagePath` matches the old user folder path.
6. Double-click `ProfileImagePath` and update the **Value data** to reflect the new folder name (e.g., `C:\Users\NewName`).
7. Restart your PC and sign back into your renamed account.

---

## How to Check Wi-Fi Signal Strength on Windows 11

_Reference: [Windows Central — How to check Wi-Fi signal strength on Windows 11](https://www.windowscentral.com/software-apps/windows-11/how-to-check-wi-fi-signal-strength-on-windows-11)_

### Option 1: From the Taskbar

1. Click the **Network/Wi-Fi icon** on the right side of the Taskbar to open Quick Settings.
2. Click the **Manage Wi-Fi connections** arrow (`>`) next to the Wi-Fi toggle.
3. Check the number of solid bars on the Wi-Fi icon next to your active network (1 bar = weak, 2 bars = fair, 3–4 bars = strong/optimal).

### Option 2: From the Settings App

1. Open **Settings** (`Win + I`).
2. Select **Network & internet** > **Wi-Fi**.
3. Check the wireless icon next to your active connection name to view the signal bar indicator.

### Option 3: From the Legacy Control Panel

1. Open **Control Panel** and go to **Network and Internet** > **Network and Sharing Center**.
2. Look under the **View your active networks** section—the green signal bars next to **Connections** display your current Wi-Fi strength.
3. _(Optional)_ Click the blue connection link to open **Wi-Fi Status** for speed and duration details.

### Option 4: Using PowerShell

1. Open **Start**, search for **PowerShell**, and launch it.
2. Run the following command to extract just the signal percentage:
   ```powershell
   (netsh wlan show interfaces) -Match '^\s+Signal' -Replace '^\s+Signal\s+:\s+',''
   ```
3. Review the percentage output (`0%` to `100%`):
   - **80% – 100%:** Excellent/reliable signal.
   - **70% – 79%:** Good for general browsing and streaming.
   - **Below 60%:** Weak signal; prone to drops or slow speeds.

### Option 5: Using Command Prompt

1. Open **Start**, search for **Command Prompt**, and launch it.
2. Run:
   ```cmd
   netsh wlan show interfaces
   ```
3. Locate the **Signal** field in the output (a value of `80%` or higher indicates a strong connection).

---

## Personalization & Themes (Windows 10/11)

Windows stores themes and wallpapers in different system directories depending on whether they are built-in, downloaded from the Microsoft Store, or synced via Windows Spotlight:

- **Default / Built-in Themes:**
  ```text
  C:\Windows\Resources\Themes
  ```
- **Installed / Downloaded Themes (Microsoft Store):**
  ```text
  %LocalAppData%\Microsoft\Windows\Themes
  ```
  _(Expands to `C:\Users\{username}\AppData\Local\Microsoft\Windows\Themes`)_
- **Default Desktop Wallpapers & Images:**
  ```text
  C:\Windows\Web\Wallpaper
  ```
- **Windows Spotlight Lock Screen Assets:**
  ```text
  %LocalAppData%\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets
  ```
  _(Note: To view Spotlight images, copy the files from this folder to another directory and append `.jpg` to their filenames.)_

### How to Open These Folders Quickly

1. Press `Win + R` to open the **Run** dialog box.
2. Paste any of the paths above (such as `%LocalAppData%\Microsoft\Windows\Themes`) and press **Enter**.
3. _(Tip: Enable **View** > **Show** > **Hidden items** in File Explorer if you are browsing manually to `AppData`.)_
