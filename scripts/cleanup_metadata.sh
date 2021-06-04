if [ "$(uname)" == "Darwin" ]; then
  # Remove all ._ files using dot_clean - Reference: man dot_clean
  dot_clean -n .
  # Also you can use: find . -name '._*' -type f -delete
  # Another alternative is:  find . -name '._*' -exec rm -rf {} \;

  # Remove all .DS_Store files - Reference: man find
  find . -name '.DS_Store' -type f -delete

  # Disable Creation of Metadata Files on Network Volumes 
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  # Disable Creation of Metadata Files on USB Volumes
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
  
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    find . -name '._*' -type f -delete
    find . -name '.DS_Store' -type f -delete
fi
