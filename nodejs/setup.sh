# Install Node Version Manager (Linux)
# https://github.com/creationix/nvm
if ! [ -d ~/.nvm/ ]; then curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash; fi
# Install Node.js and select version 7 as default
source ~/.nvm/nvm.sh
nvm install 7 && nvm alias default 7