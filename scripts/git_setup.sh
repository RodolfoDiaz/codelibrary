#!/usr/bin/env bash

OS="$(uname -s)"

# ------------------------------------------------------------------------------
# OS-Specific Installation & Credential Helper Configuration
# ------------------------------------------------------------------------------
case "${OS}" in
    Darwin*)
        echo "Installing/Updating Git on macOS..."
        # Note: Add Homebrew path to ~/.zshrc or ~/.bash_profile:
        # Apple Silicon: export PATH="/opt/homebrew/bin:${PATH}"
        # Intel Mac:      export PATH="/usr/local/bin:${PATH}"
        brew install git
        brew upgrade git

        # macOS Native Keychain Helper
        git config --global credential.helper osxkeychain
        ;;

    Linux*)
        echo "Installing/Updating Git on Linux..."
        sudo add-apt-repository ppa:git-core/ppa -y
        sudo apt-get update
        sudo apt-get install git -y

        # Uncomment to configure Git Credential Manager (GCM) on Linux via pass/gpg:
        # sudo apt-get install gpg pass -y
        # wget "https://github.com/GitCredentialManager/git-credential-manager/releases/latest/download/gcm-linux_amd64.deb" -O /tmp/gcm.deb
        # sudo dpkg -i /tmp/gcm.deb
        # git-credential-manager configure
        # git config --global credential.credentialStore gpg
        ;;

    MINGW* | MSYS* | CYGWIN*)
        echo "Downloading/Updating Git for Windows..."
        winget install --id Git.Git -e --source winget

        # 'wincred' is deprecated. Modern Git for Windows uses 'manager' (GCM)
        git config --global credential.helper manager

        # Scope credentials by path on host domains
        git config --global credential.https://github.com.useHttpPath true
        git config --global credential.https://dev.azure.com.useHttpPath true
        ;;

    *)
        echo "Unsupported OS platform: ${OS}"
        exit 1
        ;;
esac

# ------------------------------------------------------------------------------
# User & Global Configurations
# ------------------------------------------------------------------------------
git config --global user.email "{ID}+{username}@users.noreply.github.com"
git config --global user.name "RodolfoDiaz"
git config --global core.editor "nano"

# Optional global tweaks:
# git config --global init.defaultBranch main
# git config --global core.autocrlf input   # macOS / Linux
# git config --global core.autocrlf true    # Windows

echo "--- System-level Configurations ---"
git config --list --system || true

echo "--- Global Configurations ---"
git config --list --global

# ------------------------------------------------------------------------------
# Initial Repo Bootstrap Example
# ------------------------------------------------------------------------------
if [ "${1:-}" = "new" ]; then
    mkdir -p my_new_repo
    cd my_new_repo || exit 1

    git init -b main
    git remote add origin https://github.com/[your-git-org]/[new-git-repo].git

    echo "My new repository test file" >> test.txt
    touch setup.sh

    git add .
    git commit -m "Initial commit"
    git push -u origin main

    # Inspect tree contents
    git ls-tree HEAD . -l

    # Grant executable permission in Git index
    git update-index --chmod=+x setup.sh
    git commit -m "Make setup.sh executable"
    git push
fi
