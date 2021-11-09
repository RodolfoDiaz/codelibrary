# Install Node.js
# https://nodejs.org/
# Get .gitignore templates at this link: https://github.com/github/gitignore/blob/master/Node.gitignore
if [ "$(uname)" == "Darwin" ]; then
    brew install node
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Install Node.js using APT
    # curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    # sudo apt install -y nodejs
    
    # Install Node Version Manager - https://github.com/nvm-sh/nvm
    if ! [ -d ~/.nvm/ ]; then
        cd ~
        wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
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
fi
