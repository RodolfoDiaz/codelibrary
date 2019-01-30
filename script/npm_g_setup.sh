# Uninstall npm global packages
if [ "$1" == "u" ]; then
    npm uninstall -g typescript
    npm uninstall -g jshint
    npm uninstall -g eslint-plugin-angular
    npm uninstall -g eslint
    npm uninstall -g @angular/cli
fi

# Install npm global packages
if [ "$1" == "i" ]; then
    npm install -g typescript@latest
    npm install -g jshint@latest
    npm install -g eslint@latest
    npm install -g eslint-plugin-angular@latest
    npm install -g @angular/cli@latest
fi

npm update -g
npm cache verify
npm list -g --depth=0