#!/usr/bin/env bash
set -euo pipefail

# Install Node.js - https://nodejs.org/en
# .gitignore templates for the following:
# - Node.js / JavaScript apps: https://github.com/github/gitignore/blob/main/Node.gitignore
# - Visual Studio apps: https://github.com/github/gitignore/blob/main/VisualStudio.gitignore

ACTION="${1:-}"

if [[ "$ACTION" != "i" && "$ACTION" != "u" ]]; then
    echo "Usage: $0 [i|u]"
    echo "  i : Install Node.js"
    echo "  u : Uninstall Node.js"
    exit 1
fi

OS="$(uname -s)"

case "$OS" in
    Darwin*)
        if ! command -v brew > /dev/null 2>&1; then
            echo "Error: Homebrew is not installed. Visit https://brew.sh/"
            exit 1
        fi

        if [[ "$ACTION" == "i" ]]; then
            brew update
            brew install node

            npm install -g npm@latest
        else
            brew uninstall node
        fi
        ;;

    Linux*)
        export NVM_DIR="$HOME/.nvm"

        if [[ "$ACTION" == "i" ]]; then
            if [[ ! -d "$NVM_DIR" ]]; then
                # Install NVM (Node Version Manager) if not already installed
                # https://github.com/nvm-sh/nvm#installing-and-updating
                curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.41.0/install.sh | bash
            fi

            # Load nvm into current script session
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

            nvm install --lts --latest-npm
            nvm alias default 'lts/*'
            nvm use default
            nvm set-colors cgYmW
            nvm ls

            echo "Restart your terminal or run 'source ~/.bashrc' (or ~/.zshrc) to use Node.js."
        else
            # Uninstall Node.js and NVM
            # https://github.com/nvm-sh/nvm#uninstalling--removal
            $ nvm_dir="${NVM_DIR:-~/.nvm}"
            $ nvm unload
            $ rm -rf "$nvm_dir"

            rm -rf "$HOME/.npm" "$HOME/.npmrc"
            echo "Removed NVM and Node.js. Remember to remove NVM lines from ~/.bashrc or ~/.zshrc. (see NVM - Uninstalling / Removal section in the GitHub documentation)."
        fi
        ;;

    MINGW* | MSYS* | CYGWIN*)
        if ! command -v winget.exe > /dev/null 2>&1; then
            echo "Error: winget is not available on this system."
            exit 1
        fi

        if [[ "$ACTION" == "i" ]]; then
            # Use OpenJS.NodeJS.LTS for LTS, or OpenJS.NodeJS for Current
            winget.exe install --id OpenJS.NodeJS.LTS -e --source winget --accept-package-agreements --accept-source-agreements

            npm install -g npm@latest
        else
            winget.exe uninstall --id OpenJS.NodeJS.LTS -e
        fi
        ;;

    *)
        echo "Unsupported operating system: $OS"
        exit 1
        ;;
esac
