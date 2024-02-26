# Install the .NET SDK
# https://dotnet.microsoft.com/download
if [ "$(uname)" == "Darwin" ]; then
    brew install --cask dotnet-sdk
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Install .NET in Linux
    # https://learn.microsoft.com/en-us/dotnet/core/install/linux

    sudo snap remove dotnet-sdk
    sudo apt remove 'dotnet*'
    sudo apt remove 'aspnetcore*'
    sudo apt remove 'netstandard*'
    sudo rm /etc/apt/sources.list.d/microsoft-prod.list
    sudo rm /etc/apt/sources.list.d/microsoft-prod.list.save
    sudo apt update
    sudo apt install dotnet8
    dotnet --info

fi