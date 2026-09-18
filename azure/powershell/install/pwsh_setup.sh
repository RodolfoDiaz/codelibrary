#!/usr/bin/env bash

# Install or Uninstall PowerShell across macOS, Linux (Ubuntu/Debian), and Windows
# Documentation: https://learn.microsoft.com/powershell/scripting/overview

ACTION="$1"

if [ -z "$ACTION" ]; then
    echo "Usage: $0 [i|u]"
    echo "  i : Install / Upgrade PowerShell"
    echo "  u : Uninstall PowerShell"
    exit 1
fi

OS_TYPE="$(uname -s)"

case "$OS_TYPE" in
    Darwin*)
        # macOS Installation
        # https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-macos
        if [ "$ACTION" == "i" ]; then
            echo "Installing / Upgrading PowerShell on macOS..."
            brew install --cask powershell
            echo "PowerShell installed successfully. Launching 'pwsh'..."
            pwsh
        elif [ "$ACTION" == "u" ]; then
            echo "Uninstalling PowerShell on macOS..."
            brew uninstall --cask powershell
        fi
        ;;

    Linux*)
        # Linux (Ubuntu/Debian) Installation
        # https://learn.microsoft.com/powershell/scripting/install/install-ubuntu
        if [ "$ACTION" == "i" ]; then
            echo "Installing PowerShell on Linux..."

            # Update package index and install prerequisites
            sudo apt update
            sudo apt install -y wget apt-transport-https software-properties-common

            # Download and register Microsoft repository GPG keys (Ubuntu 24.04 LTS)
            DEB_PKG="packages-microsoft-prod.deb"
            wget -q "https://packages.microsoft.com/config/ubuntu/24.04/${DEB_PKG}"
            sudo dpkg -i "$DEB_PKG"
            rm -f "$DEB_PKG"

            # Enable universe repository and install PowerShell
            sudo add-apt-repository universe -y
            sudo apt update
            sudo apt install -y powershell

            echo "PowerShell installed successfully. Launching 'pwsh'..."
            pwsh
        elif [ "$ACTION" == "u" ]; then
            echo "Uninstalling PowerShell on Linux..."
            sudo apt remove -y powershell
            sudo apt autoremove -y
        fi
        ;;

    MINGW* | MSYS* | CYGWIN*)
        # Windows via Git Bash / MSYS2
        # https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-windows
        if [ "$ACTION" == "i" ]; then
            echo "Installing PowerShell on Windows 11 via winget..."
            winget install --id Microsoft.PowerShell --source winget --accept-package-agreements --accept-source-agreements
            echo "PowerShell installed successfully."
        elif [ "$ACTION" == "u" ]; then
            echo "Uninstalling PowerShell on Windows 11 via winget..."
            winget uninstall --id Microsoft.PowerShell
        fi
        ;;

    *)
        echo "Unsupported Operating System: $OS_TYPE"
        exit 1
        ;;
esac
