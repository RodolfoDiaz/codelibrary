# Install Azure Functions Core Tools
# https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local
if [ "$1" == "" ]; then
    echo "No argurment found.  Use 'i' to install or 'u' to uninstall."
fi

if [ "$(uname)" == "Darwin" ]; then
    if [ "$1" == "i" ]; then
        echo "Install Azure Functions Core Tools on macOS"
        brew tap azure/functions
        brew install azure-functions-core-tools@3
        # if upgrading on a machine that has 2.x installed
        brew link --overwrite azure-functions-core-tools@3
        echo "Start Azure Functions Core Tools "
        func
    fi

    if [ "$1" == "u" ]; then
        echo "Uninstalling Azure Functions Core Tools on macOS"
        brew uninstall azure-functions-core-tools@3
    fi
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    if [ "$1" == "i" ]; then
        echo "Install Azure Functions Core Tools on Linux with apt"
        curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
        sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
        sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs)-prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list'
        sudo apt-get update
        sudo apt-get update
        sudo apt-get install azure-functions-core-tools-3
        echo "Start Azure Functions Core Tools "
        func
    fi

    if [ "$1" == "u" ]; then
        echo "Uninstalling Azure Functions Core Tools on Linux"
        sudo apt-get remove -y azure-functions-core-tools-3
    fi
fi
