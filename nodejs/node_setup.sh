# Install Node.js
# https://nodejs.org/
# Get .gitignore templates at this link: https://github.com/github/gitignore/blob/master/Node.gitignore
if [ "$(uname)" == "Darwin" ]; then
    brew install node
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Install Node Version Manager - https://github.com/creationix/nvm
    if ! [ -d ~/.nvm/ ]; then
      curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
    fi
    # Install Node.js and select the latest version as default
    source ~/.nvm/nvm.sh
    nvm install 9 && nvm alias default 9
fi
