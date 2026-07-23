# Install Node.js
# https://nodejs.org/
# Get .gitignore templates at this link: https://github.com/github/gitignore/blob/master/Node.gitignore

if [ "$1" == "" ]; then
    echo "No argurment found.  Use 'i' to install or 'u' to uninstall."
fi

if [ "$(uname)" == "Darwin" ]; then
    if [ "$1" == "i" ]; then
        brew update
        brew install node
    fi

    if [ "$1" == "u" ]; then
        brew uninstall node
    fi

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then

    if [ "$1" == "i" ]; then
        # Install Node.js using APT
        # sudo apt update
        # curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        # sudo apt install -y nodejs

        # Install Node Version Manager - https://github.com/nvm-sh/nvm#installing-and-updating
        if ! [ -d ~/.nvm/ ]; then
            cd ~
            wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
        fi

        source ~/.nvm/nvm.sh

        # Install Node.js and select the latest LTS version as default
        nvm install --lts --latest-npm
        nvm set-colors cgYmW
        nvm use --lts

        # Install Latest version:
        # nvm install node --reinstall-packages-from=node
        # Install Stable (LTS) version:
        # nvm install lts/* --reinstall-packages-from=node

        nvm ls
        #  nvm uninstall <version>
        # npm update -g
        echo "RESTART YOUR TERMINAL OR RUN 'source ~/.bashrc' TO USE NODE.JS"
    fi

    if [ "$1" == "u" ]; then
        # Uninstall Node.js and remove NVM
        rm -rf ~/.npm
        rm -rf ~/.npmrc
        rm -rf ~/.nvm
    fi
fi
