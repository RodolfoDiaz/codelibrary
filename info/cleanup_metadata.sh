# Remove all Mac generated files '._'
# man dot_clean
dot_clean -n .
# An alternative is to use the following:  find . -name '._*' -exec rm -rf {} \;
# Find .DS_Store files
find . -name ".DS_Store"
# man find
# Recursively Remove .DS_Store
find . -name '.DS_Store' -type f -delete
# Disable Creation of Metadata Files on Network Volumes 
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Disable Creation of Metadata Files on USB Volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Reference: http://docs.hardentheworld.org/OS/MacOS_10.12_Sierra/