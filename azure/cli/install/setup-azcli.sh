# Install Azure CLI
# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
if [ "$1" == "" ]; then
    echo "No argurment found.  Use 'i' to install or 'u' to uninstall."
fi

if [ "$(uname)" == "Darwin" ]; then
    if [ "$1" == "i" ]; then
        echo "Install Azure CLI on macOS"
        # https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos
        brew update && brew install azure-cli
        echo "The CLI provides an in-tool command to update to the latest version:"
        az upgrade
        echo "Start Azure CLI"
        az
    fi

    if [ "$1" == "u" ]; then
        echo "Uninstalling Azure CLI on macOS"
        brew uninstall azure-cli
    fi
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    if [ "$1" == "i" ]; then
        echo "Install Azure CLI on Linux with apt"
        # https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt
        curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
        echo "The CLI provides an in-tool command to update to the latest version:"
        az upgrade
        echo "Start Azure CLI"
        az
    fi

    if [ "$1" == "u" ]; then
        echo "Uninstalling Azure CLI on Linux"
        sudo apt-get remove -y azure-cli
    fi
fi
