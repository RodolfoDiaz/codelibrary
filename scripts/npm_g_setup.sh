# Uninstall npm global packages
if [ "$1" == "u" ]; then
    npm uninstall -g jshint
    npm uninstall -g eslint
fi

# Install npm global packages
if [ "$1" == "i" ]; then
    npm install -g jshint@latest
    npm install -g eslint@latest
fi

# npm update -g
# npm install npm@latest -g

npm cache verify

npm list -g --depth=0