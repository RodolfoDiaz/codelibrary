#!/usr/bin/env bash
set -euo pipefail

# Install Node.js
# https://nodejs.org/
# .gitignore template: https://github.com/github/gitignore/blob/master/Node.gitignore

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
        else
            brew uninstall node
        fi
        ;;

    Linux*)
        export NVM_DIR="$HOME/.nvm"

        if [[ "$ACTION" == "i" ]]; then
            if [[ ! -d "$NVM_DIR" ]]; then
                curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
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
            rm -rf "$HOME/.npm" "$HOME/.npmrc" "$NVM_DIR"
            echo "Removed NVM and Node.js. Remember to remove NVM lines from ~/.bashrc or ~/.zshrc."
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
        else
            winget.exe uninstall --id OpenJS.NodeJS.LTS -e
        fi
        ;;

    *)
        echo "Unsupported operating system: $OS"
        exit 1
        ;;
esac
