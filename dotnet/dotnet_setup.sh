#!/usr/bin/env bash

# Install or Uninstall the latest .NET SDK
# Documentation: https://learn.microsoft.com/en-us/dotnet/core/install/

ACTION="$1"

if [ -z "$ACTION" ]; then
    echo "Usage: $0 [i|u]"
    echo "  i : Install latest .NET SDK"
    echo "  u : Uninstall .NET SDK"
    exit 1
fi

OS="$(uname -s)"

case "$OS" in
    Darwin)
        # macOS: Brew's dotnet-sdk cask automatically pulls the latest stable version
        if [ "$ACTION" == "i" ]; then
            echo "Installing latest .NET SDK via Homebrew..."
            brew install --cask dotnet-sdk
            dotnet --info
        elif [ "$ACTION" == "u" ]; then
            echo "Uninstalling .NET SDK via Homebrew..."
            brew uninstall --cask dotnet-sdk
        fi
        ;;

    Linux)
        # Linux APT: Installing the meta-package 'dotnet-sdk' pulls the latest version
        # Or explicitly target 'dotnet-sdk-10.0' for .NET 10 LTS
        if [ "$ACTION" == "i" ]; then
            echo "Updating package lists and installing latest .NET SDK..."
            sudo apt-get update
            sudo apt-get install -y dotnet-sdk-10.0 || sudo apt-get install -y dotnet-sdk
            dotnet --info
        elif [ "$ACTION" == "u" ]; then
            echo "Removing .NET SDK and runtime packages..."
            sudo apt-get remove --purge -y 'dotnet*' 'aspnetcore*' 'netstandard*'
            sudo apt-get autoremove -y

            if command -v snap &> /dev/null; then
                sudo snap remove dotnet-sdk 2> /dev/null || true
            fi

            echo ".NET SDK uninstalled successfully."
        fi
        ;;

    MINGW* | MSYS* | CYGWIN*)
        # Windows via Git Bash / MSYS: Using Microsoft.DotNet.SDK installs the latest release
        if [ "$ACTION" == "i" ]; then
            echo "Installing latest .NET SDK via Winget..."
            winget.exe install --id Microsoft.DotNet.SDK --source winget --accept-package-agreements --accept-source-agreements
            dotnet --info
        elif [ "$ACTION" == "u" ]; then
            echo "Uninstalling .NET SDK via Winget..."
            winget.exe uninstall --id Microsoft.DotNet.SDK
        fi
        ;;

    *)
        echo "Unsupported OS environment: $OS"
        exit 1
        ;;
esac
