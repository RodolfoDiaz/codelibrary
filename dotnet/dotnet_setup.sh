# Install the .NET SDK
# https://dotnet.microsoft.com/download
if [ "$(uname)" == "Darwin" ]; then
    #brew install --cask dotnet  # version 3.1
    brew install --cask dotnet-sdk  # version 5.0
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Install .NET in Linux
    # https://learn.microsoft.com/en-us/dotnet/core/install/linux

    # Get Ubuntu version
    declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)

    # Download Microsoft signing key and repository
    wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

    # Install Microsoft signing key and repository
    sudo dpkg -i packages-microsoft-prod.deb

    # Clean up
    rm packages-microsoft-prod.deb

    # Update packages
    sudo apt update

    # Install the SDK
    sudo apt update; \
      sudo apt install -y apt-transport-https && \
      sudo apt update && \
      sudo apt install -y dotnet-sdk-7.0

    # Install the runtime
    sudo apt update; \
      sudo apt install -y apt-transport-https && \
      sudo apt update && \
      sudo apt install -y aspnetcore-runtime-7.0

    # Alternative install for Continuous Integration (CI) scenarios
    # wget -q -O - https://dot.net/v1/dotnet-install.sh | bash -s -- --version 3.1.102
    # export PATH="~/.dotnet:$PATH"
    # echo "export PATH=~/.dotnet:\$PATH" >> ~/.bashrc

    # --- Remove old version ---
    # sudo apt purge -y aspnetcore-runtime-6.0
    # sudo apt purge -y dotnet-sdk-6.0
    # sudo apt autoremove
fi