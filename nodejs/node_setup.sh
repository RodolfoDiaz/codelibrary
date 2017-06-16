# Install Node.js
# https://nodejs.org/
if [ "$(uname)" == "Darwin" ]; then
    brew install node
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Install Node Version Manager - https://github.com/creationix/nvm
    if ! [ -d ~/.nvm/ ]; then
      curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
    fi
    # Install Node.js and select version 8 as default
    source ~/.nvm/nvm.sh
    nvm install 8 && nvm alias default 8
fi