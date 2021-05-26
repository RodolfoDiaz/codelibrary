# Install Node.js
# https://nodejs.org/
# Get .gitignore templates at this link: https://github.com/github/gitignore/blob/master/Node.gitignore
if [ "$(uname)" == "Darwin" ]; then
    brew install node
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Install Node.js using APT
    # curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
    # sudo apt-get install -y nodejs
    
    # Install Node Version Manager - https://github.com/nvm-sh/nvm
    if ! [ -d ~/.nvm/ ]; then
        cd ~
        wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
        source ~/.nvm/nvm.sh
    fi
    # Install Node.js and select the latest version as default
    nvm install 14 && nvm alias default 14

    # Latest version:
    #nvm install node --reinstall-packages-from=node
    # Stable (LTS) version:
    #nvm install lts/* --reinstall-packages-from=node

    # npm update -g
fi
