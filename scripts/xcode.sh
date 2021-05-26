if [ "$(uname)" != "Darwin" ]; then
  echo 'This script is only for macOS'
  exit
fi
echo 'Install Xcode Command Line Tools'
sudo rm -rf /Library/Developer/CommandLineTools
xcode-select --install
softwareupdate --all --install --force
