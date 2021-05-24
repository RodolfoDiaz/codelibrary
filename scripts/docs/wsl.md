# Windows Subsystem for Linux

The [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/) lets developers run a GNU/Linux environment -- including most command-line tools, utilities, and applications -- directly on Windows, unmodified, without the overhead of a traditional virtual machine or dual-boot setup.

## Install WSL

[Manual Installation Steps](https://docs.microsoft.com/en-us/windows/wsl/install-win10#manual-installation-steps)


## Set your distribution version to WSL 1 or WSL 2

    wsl --list --verbose

    wsl --set-version <distribution name> <versionNumber>

If you want to make WSL 2 your default architecture you can do so with this command:

    wsl --set-default-version 2

## VHDX File location

1. Browse to: %LocalAppData%\Packages
2. Use the following PowerShell command to get the WSL Distro:

    Get-AppxPackage *ubuntu*

3. Open the folder <WSL Distro>\LocalState

## Uninstalling Linux distro using PowerShell

    Get-AppxPackage *ubuntu*
    Get-AppxPackage <WSL Distro> | Remove-AppxPackage

## Get started using Visual Studio Code

[Install VS Code and the Remote WSL extension](https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-vscode)

[Developing in WSL](https://code.visualstudio.com/docs/remote/wsl)

Extensions are installed in a per user extensions folder. Depending on your platform, the location is in the following folder:

* Windows %USERPROFILE%\.vscode\extensions
* macOS ~/.vscode/extensions
* Linux ~/.vscode/extensions

## Windows interoperability with Linux

Run Linux binaries from the Windows Command Prompt (CMD) or PowerShell using wsl <command> (or wsl.exe <command>).

    wsl ls -la

More information [here](https://docs.microsoft.com/en-us/windows/wsl/interop#run-linux-tools-from-a-windows-command-line).


## Install a Windows Subsystem for Linux GUI with Xfce4
When command-line tools aren’t enough, it’s time to break out the GUIs. If you need to run a graphical utility on WSL, explore a custom distro, or you’re not familiar with bash yet, you can install a Linux GUI.

### Xfce
Linux has many available desktop environments. One of the most common ones to set up for WSL is called Xfce. At the time of this writing, Xfce is at version 4. Other desktop environments are available but in this article, you’ll learn how to get Xfce4 set up.

### xRDP
When you have a Linux desktop environment set up, you’ll need a service that understands the RDP protocol. In this article, we’ll focus on the xRDP server. xRDP is an open source RDP server for Linux that allows you to use RDP clients to connect to Linux just as if you can Windows hosts.

### Setting Up
To access a Linux GUI from Windows with Xfce4 and xRDP, follow the instructions below. In a WSL terminal:

1. Download and install Xfce4 – Download and install Xfce4 using the command sudo apt-get -y install xfce4 && sudo apt-get -y install xubuntu-desktop. This will take a while. Stand by.
2. Install the xRDP server – Download and install xRDP by running sudo apt-get -y install xrdp.
3. Configure xRDP for xfce4 – echo xfce4-session > ~/.xsession
4. Restart xRDP – sudo service xrdp restart
5. Find the WSL distro IP address – ifconfig | grep inet

At this point, you should be able to open an RDP session from Windows 10. Open up remote desktop connection window using mstsc and provide the Linux IP address found in step #5.