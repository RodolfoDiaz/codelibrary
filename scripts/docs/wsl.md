# Windows Subsystem for Linux (WSL)

The [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/) lets developers run a GNU/Linux environment—including most command-line tools, utilities, and applications—directly on Windows, unmodified, without the overhead of a traditional virtual machine or dual-boot setup.

## Install WSL

On modern versions of Windows 10 (version 2004 and higher) and Windows 11, you can install WSL with a single command in an administrator PowerShell or Windows Command Prompt:

```powershell
wsl --install
```

By default, this installs Ubuntu and sets WSL 2 as your default architecture. For older builds or custom setups, refer to the [Manual Installation Steps](https://learn.microsoft.com/en-us/windows/wsl/install-manual).

## Set your distribution version to WSL 1 or WSL 2

To check the WSL version assigned to each of your installed Linux distributions, run:

```powershell
wsl --list --verbose
```

To change a specific distribution's version, use:

```powershell
wsl --set-version <distribution name> <versionNumber>
```

If you want to make WSL 2 your default architecture for all future installations, run:

```powershell
wsl --set-default-version 2
```

## VHDX file location

WSL 2 stores Linux files inside a virtual hard disk (`ext4.vhdx`).

1. Browse to: `%LocalAppData%\Packages`
2. Use the following PowerShell command to find your WSL distribution's exact package folder name:
   ```powershell
   Get-AppxPackage *ubuntu*
   ```
3. Open the folder `<PackageFamilyName>\LocalState` to locate `ext4.vhdx`.

_(Note: Depending on your WSL version and how the distro was installed, newer distributions may store their VHDX files under `%LocalAppData%\wsl` instead.)_

## Uninstalling a Linux distribution

The recommended way to completely uninstall a distribution and delete its associated virtual hard disk is using the built-in `wsl` command:

```powershell
wsl --list
wsl --unregister <DistributionName>
```

_(Note: If you installed the distribution from the Microsoft Store, you may also want to uninstall the app via **Settings > Apps** or PowerShell's `Remove-AppxPackage` to remove the launcher shortcut.)_

## Get started using Visual Studio Code

- [Install VS Code and the WSL extension](https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-vscode) _(formerly known as Remote - WSL)_
- [Developing in WSL](https://code.visualstudio.com/docs/remote/wsl)

Extensions are installed in a per-user extensions folder. Depending on your platform, the location is in the following folder:

- **Windows:** `%USERPROFILE%\.vscode\extensions`
- **macOS:** `~/.vscode/extensions`
- **Linux:** `~/.vscode/extensions`

_(Note: When connected to WSL in VS Code, Linux-specific extensions are installed inside WSL at `~/.vscode-server/extensions`.)_

## Windows interoperability with Linux

Run Linux binaries from the Windows Command Prompt (CMD) or PowerShell using `wsl <command>` (or `wsl.exe <command>`):

```powershell
wsl ls -la
```

More information can be found in the [Windows interoperability documentation](https://learn.microsoft.com/en-us/windows/wsl/interop#run-linux-tools-from-a-windows-command-line).

## Running Linux GUI applications

### Option 1: Built-in WSLg (Recommended)

If you are running **Windows 11** or an updated build of **Windows 10**, WSL includes built-in support for Linux GUI applications (**WSLg**) out of the box. You do not need to install a desktop environment or RDP server; simply install a Linux GUI app (such as `gedit` or `x11-apps`) via `apt` and launch it directly from your WSL terminal.

### Option 2: Full Desktop GUI with Xfce4 and xRDP

If you want a full Linux desktop environment or are running an older version of Windows 10 without WSLg, you can set up **Xfce4** alongside **xRDP** (an open-source Remote Desktop Protocol server for Linux).

#### Setting Up

To access a full Linux desktop from Windows with Xfce4 and xRDP, run the following commands inside your WSL terminal:

1. **Update packages and install Xfce4** (this will take a while):
   ```bash
   sudo apt update && sudo apt -y install xfce4 xubuntu-desktop
   ```
2. **Install the xRDP server:**
   ```bash
   sudo apt -y install xrdp
   ```
3. **Configure xRDP to use Xfce4:**
   ```bash
   echo xfce4-session > ~/.xsession
   ```
4. **Start or restart the xRDP service:**
   ```bash
   sudo service xrdp restart
   ```
5. **Find your WSL distribution's IP address:**
   ```bash
   ip addr | grep inet
   ```
   _(Note: Look for the `eth0` interface IP address, typically starting with `172.x.x.x`. Alternatively, you can often connect directly using `localhost`.)_

At this point, open the Windows Remote Desktop Connection app (`mstsc`), enter the Linux IP address found in step 5 (or `localhost`), and log in with your WSL Linux username and password.
