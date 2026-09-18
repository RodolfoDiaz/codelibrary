#!/usr/bin/env bash
set -e

OS="$(uname -s)"

# Detect Windows environments (Git Bash, WSL, MSYS, Cygwin)
if [[ "$OS" == *"MINGW"* || "$OS" == *"MSYS"* || "$OS" == *"CYGWIN"* ]]; then
    echo "Installing MongoDB Community Edition on Windows via winget..."
    # https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-windows/

    if [[ "$1" == "u" ]]; then
        echo "Uninstalling MongoDB..."
        winget uninstall --id MongoDB.Server -e
        winget uninstall --id MongoDB.Compass -e || true
        winget uninstall --id MongoDB.Shell -e || true
    fi

    if [[ "$1" == "i" ]]; then
        echo "Installing MongoDB Server, Shell (mongosh), and Compass..."
        # Install MongoDB Server
        winget install --id MongoDB.Server -e --source winget

        # Install MongoDB Shell (mongosh) and Compass (GUI)
        winget install --id MongoDB.Shell -e --source winget
        winget install --id MongoDB.Compass -e --source winget

        echo ""
        echo "Installation complete!"
        echo "MongoDB runs as a Windows Service automatically (MongoDB)."
        echo "To start/stop the service manually in PowerShell (Admin):"
        echo "  Start-Service MongoDB"
        echo "  Stop-Service MongoDB"
        echo "To access the interactive shell, open a new terminal and run: mongosh"
    fi

elif [[ "$OS" == "Darwin" ]]; then
    echo "Managing MongoDB Community Edition on macOS"
    # https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-os-x/

    if [[ "$1" == "u" ]]; then
        echo "Uninstalling MongoDB..."
        brew services stop mongodb-community || true
        brew uninstall mongodb-community

        # Remove custom local database folder and launcher
        rm -rf ~/mongoData
        rm -f ~/mongod
    fi

    if [[ "$1" == "i" ]]; then
        echo "Installing MongoDB..."
        brew update
        # Tap official MongoDB repository
        brew tap mongodb/brew
        brew install mongodb-community

        # Create local database directory and start runner
        mkdir -p ~/mongoData
        echo '#!/usr/bin/env bash' > ~/mongod
        echo 'mongod --dbpath=~/mongoData --nojournal' >> ~/mongod
        chmod +x ~/mongod

        # Usage guide:
        # Start as a background service:
        #   brew services start mongodb-community
        # Access the shell using:
        #   mongosh
    fi

elif [[ "$OS" == "Linux" ]]; then
    echo "Installing MongoDB Community Edition on Ubuntu/Linux"
    # https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-ubuntu/

    if [[ "$1" == "i" ]]; then
        # 1- Install required dependencies
        sudo apt-get update
        sudo apt-get install -y gnupg curl

        # 2- Import the official MongoDB public GPG key (modern non-apt-key method)
        curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc \
            | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg --yes

        # 3- Add the MongoDB repository source list
        UBUNTU_CODENAME="$(lsb_release -cs 2> /dev/null || echo "jammy")"
        echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu ${UBUNTU_CODENAME}/mongodb-org/7.0 multiverse" \
            | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

        # 4- Update package list and install MongoDB
        sudo apt-get update
        sudo apt-get install -y mongodb-org

        # 5- Start and enable the MongoDB service
        sudo systemctl daemon-reload
        sudo systemctl start mongod
        sudo systemctl enable mongod

        echo "MongoDB service started."
        echo "To stop service: sudo systemctl stop mongod"
        echo "To access interactive shell: mongosh"
    fi
else
    echo "Unsupported operating system: $OS"
    exit 1
fi
