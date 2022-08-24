# Homebrew - The missing package manager for macOS
# https://brew.sh/

if [ "$(uname)" != "Darwin" ]; then
  echo 'This script is only for macOS'
  exit
fi

# Update MacOS with the latest updates
softwareupdate --all --install --force

if brew ls --versions > /dev/null; then
  echo "Homebrew is installed, updating..."
  brew update && brew upgrade && brew cleanup
else
  echo "Installing Homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Uninstall Homebrew applications
if [ "$1" == "u" ]; then
   brew uninstall git
   brew uninstall node
   brew uninstall p7zip
   # uninstalling dependencies for node
   brew uninstall icu4c
   # uninstalling dependecies for git
   brew uninstall gettext
   brew uninstall pcre2
fi

# Install Homebrew applications
if [ "$1" == "i" ]; then
   brew install git
   brew install node
   brew install p7zip
fi