# Install Install Azure CLI
# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
if [ "$(uname)" == "Darwin" ]; then
    # Install Azure CLI on macOS
    # https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos
    brew update && brew install azure-cli
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Install Azure CLI on Linux with apt
    # https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
fi
