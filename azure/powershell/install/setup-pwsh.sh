# Install PowerShell
# https://docs.microsoft.com/en-us/powershell/scripting/overview
if [ "$1" == "" ]; then
    echo "No argurment found.  Use 'i' to install or 'u' to uninstall."
fi

if [ "$(uname)" == "Darwin" ]; then
    if [ "$1" == "i" ]; then
        echo "Installing PowerShell on macOS"
        # https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-macos
        brew install --cask powershell
        # When new versions of PowerShell are released, update Homebrew's formulae and upgrade PowerShell:
        brew update
        brew upgrade powershell --cask
        echo "Start PowerShell"
        pwsh
    fi

    if [ "$1" == "u" ]; then
        echo "Uninstalling PowerShell on macOS"
        brew uninstall --cask powershell
    fi

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    if [ "$1" == "i" ]; then
        echo "Installing PowerShell on Linux"
        # https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux
        # Update the list of packages
        sudo apt-get update
        # Install pre-requisite packages.
        sudo apt-get install -y wget apt-transport-https
        # Download the Microsoft repository GPG keys
        # wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
        # wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
        wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
        # Register the Microsoft repository GPG keys
        sudo dpkg -i packages-microsoft-prod.deb
        # Update the list of products
        sudo apt-get update
        # Enable the "universe" repositories
        sudo add-apt-repository universe
        # Install PowerShell
        sudo apt-get install -y powershell
        echo "Start PowerShell"
        pwsh
    fi

    if [ "$1" == "u" ]; then
        echo "Uninstalling PowerShell on Linux"
        sudo apt-get remove powershell
    fi

fi
