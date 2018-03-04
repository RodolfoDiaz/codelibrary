# Install Xcode Command Line Tools
xcode-select --install
# Homebrew - The missing package manager for macOS
# https://brew.sh/
if brew ls --versions > /dev/null; then
  echo "Homebrew is installed, updating..."
  brew update && brew upgrade && brew cleanup; brew doctor
else
  echo "Installing Homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Uninstall Homebrew applications
if [ "$1" == "u" ]; then
   brew uninstall git
   brew uninstall node
   brew uninstall python
   brew uninstall unrar
   brew uninstall mongodb
   # uninstalling dependencies for node
   brew uninstall icu4c
   # uninstalling dependecies for python
   brew uninstall sqlite
   brew uninstall gdbm
   brew uninstall readline
   brew uninstall xz
   brew uninstall openssl
fi

# Install Homebrew applications
if [ "$1" == "i" ]; then
   brew install git
   brew install node
   brew install python
   brew install unrar
   brew install mongodb
fi