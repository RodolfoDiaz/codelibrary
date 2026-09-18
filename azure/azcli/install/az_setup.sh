#!/usr/bin/env bash

# Install Azure CLI
# https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

ACTION="${1:-}"

if [ -z "$ACTION" ]; then
    echo "No argument found. Use 'i' to install or 'u' to uninstall."
    exit 1
fi

OS="$(uname -s)"

case "$OS" in
    Darwin*)
        if [ "$ACTION" == "i" ]; then
            echo "Installing Azure CLI on macOS..."
            # https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos
            brew update && brew install azure-cli
            echo "Upgrading Azure CLI to the latest version..."
            az upgrade --yes
            echo "Starting Azure CLI..."
            az
        elif [ "$ACTION" == "u" ]; then
            echo "Uninstalling Azure CLI on macOS..."
            brew uninstall azure-cli
        fi
        ;;

    Linux*)
        if [ "$ACTION" == "i" ]; then
            echo "Installing Azure CLI on Linux..."
            # https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt
            curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
            echo "Upgrading Azure CLI to the latest version..."
            az upgrade --yes
            echo "Starting Azure CLI..."
            az
        elif [ "$ACTION" == "u" ]; then
            echo "Uninstalling Azure CLI on Linux..."
            sudo apt-get remove -y azure-cli
            sudo rm /etc/apt/sources.list.d/azure-cli.list
            sudo rm /etc/apt/trusted.gpg.d/azure-cli.gpg
        fi
        ;;

    MINGW* | MSYS* | CYGWIN*)
        # Windows environment via Git Bash / MSYS
        if [ "$ACTION" == "i" ]; then
            echo "Installing Azure CLI on Windows using winget..."
            # https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows
            winget.exe install --id Microsoft.AzureCLI --source winget --accept-package-agreements --accept-source-agreements
        elif [ "$ACTION" == "u" ]; then
            echo "Uninstalling Azure CLI on Windows..."
            winget.exe uninstall --id Microsoft.AzureCLI
        fi
        ;;

    *)
        echo "Unsupported Operating System: $OS"
        exit 1
        ;;
esac
