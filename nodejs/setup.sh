# Install Node Version Manager (Linux)
# https://github.com/creationix/nvm
if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    if ! [ -d ~/.nvm/ ]; then
      curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
    fi
    # Install Node.js and select version 7 as default
    source ~/.nvm/nvm.sh
    nvm install 7 && nvm alias default 7
fi