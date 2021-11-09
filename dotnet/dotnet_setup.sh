# Install .Net Framework
# https://dotnet.microsoft.com/download
if [ "$(uname)" == "Darwin" ]; then
    #brew install --cask dotnet  # version 3.1
    brew install --cask dotnet-sdk  # version 5.0
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Install dotnet using APT
    # https://docs.microsoft.com/en-us/dotnet/core/install/linux

    # Get the package based on your Ubuntu version
    # wget https://packages.microsoft.com/config/ubuntu/21.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    #wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb

    # Install the SDK
    sudo apt update; \
      sudo apt install -y apt-transport-https && \
      sudo apt update && \
      sudo apt install -y dotnet-sdk-6.0

    # Install the runtime
    sudo apt update; \
      sudo apt install -y apt-transport-https && \
      sudo apt update && \
      sudo apt install -y aspnetcore-runtime-6.0

    # Alternative install for Continuous Integration (CI) scenarios
    # wget -q -O - https://dot.net/v1/dotnet-install.sh | bash -s -- --version 3.1.102
    # export PATH="~/.dotnet:$PATH"
    # echo "export PATH=~/.dotnet:\$PATH" >> ~/.bashrc

    # --- Remove old version ---
    # sudo apt purge -y aspnetcore-runtime-5.0
    # sudo apt purge -y dotnet-sdk-5.0
    # sudo apt autoremove
fi