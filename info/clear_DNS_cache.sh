# Clearing the DNS Cache on Computers and Web Browsers
# https://support.opendns.com/hc/en-us/articles/227988627
if [ "$(uname)" == "Darwin" ]; then
    echo "Flushing local DNS cache in macOS"
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Flushing local DNS cache in Ubuntu Linux"
    sudo service network-manager restart
    #sudo /etc/init.d/nscd restart
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    echo "Flushing local DNS cache in Windows"
    ipconfig /flushdns
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    echo "Flushing local DNS cache in Windows"
    ipconfig /flushdns
fi