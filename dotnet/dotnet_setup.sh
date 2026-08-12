# Install the .NET SDK
# https://dotnet.microsoft.com/download
if [ "$1" == "" ]; then
    echo "No argurment found.  Use 'i' to install or 'u' to uninstall."
fi

if [ "$(uname)" == "Darwin" ]; then
    if [ "$1" == "i" ]; then
        brew install --cask dotnet-sdk
    fi
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Install .NET in Linux
    # https://learn.microsoft.com/en-us/dotnet/core/install/linux

    if [ "$1" == "i" ]; then
        sudo rm /etc/apt/sources.list.d/microsoft-prod.list
        sudo rm /etc/apt/sources.list.d/microsoft-prod.list.save
        sudo apt update
        sudo apt-get install -y dotnet-sdk-10.0
        dotnet --info
    fi

    if [ "$1" == "u" ]; then
        sudo snap remove dotnet-sdk -y
        sudo apt remove 'dotnet*' -y
        sudo apt remove 'aspnetcore*' -y
        sudo apt remove 'netstandard*' -y
        sudo apt autoremove -y
        echo "Uninstalled .NET SDK"
    fi

fi
