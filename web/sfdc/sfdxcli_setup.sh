#!/usr/bin/env bash
set -euo pipefail

# Install Salesforce CLI across macOS, Linux (Ubuntu), and Windows
# Docs: https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm

OS_TYPE="$(uname -s)"

install_macos() {
    echo "Detected macOS. Installing Salesforce CLI via Homebrew..."
    if ! command -v brew > /dev/null 2>&1; then
        echo "Error: Homebrew is not installed. Install it from https://brew.sh first." >&2
        exit 1
    fi
    brew install sf
}

install_linux() {
    echo "Detected Linux. Installing Salesforce CLI via npm..."
    if ! command -v npm > /dev/null 2>&1; then
        echo "Error: npm is not installed. Install Node.js and npm first (e.g., sudo apt update && sudo apt install -y nodejs npm)." >&2
        exit 1
    fi
    npm install @salesforce/cli@latest --global
}

install_windows() {
    echo "Detected Windows (${OS_TYPE}). Installing Salesforce CLI via winget..."
    if ! command -v winget > /dev/null 2>&1; then
        echo "Error: winget is not available. Ensure 'App Installer' is installed from the Microsoft Store." >&2
        exit 1
    fi
    winget install --id Salesforce.CLI --exact --accept-source-agreements --accept-package-agreements
}

case "${OS_TYPE}" in
    Darwin*)
        install_macos
        ;;
    Linux*)
        install_linux
        ;;
    MINGW64_NT* | MSYS_NT* | CYGWIN_NT*)
        install_windows
        ;;
    MINGW32_NT*)
        echo "Error: 32-bit Windows is not supported by winget or modern Salesforce CLI." >&2
        exit 1
        ;;
    *)
        echo "Unsupported operating system: ${OS_TYPE}" >&2
        exit 1
        ;;
esac

# Verify installation
if command -v sf > /dev/null 2>&1; then
    echo "Success! Installed version: $(sf --version)"
else
    echo "Installation completed, though you may need to restart your terminal for 'sf' to appear in your PATH."
fi
