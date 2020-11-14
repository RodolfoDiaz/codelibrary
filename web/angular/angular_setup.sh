# Uninstall npm global packages
if [ "$1" == "u" ]; then
    npm uninstall -g eslint-plugin-angular
    npm uninstall -g @angular/cli
    npm uninstall -g typescript
fi

# Install npm global packages
if [ "$1" == "i" ]; then
    npm install -g typescript@latest
    npm install -g @angular/cli@latest
    npm install -g eslint-plugin-angular@latest
fi

# npm update -g
npm cache verify
npm list -g --depth=0