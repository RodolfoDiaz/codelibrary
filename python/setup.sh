if [ "$(uname)" == "Darwin" ]; then
    echo "Install Python in macOS"
    brew install python
    brew install python3
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Python in Linux"
    sudo apt-get update
    sudo apt-get install python2.7 -y
    sudo apt-get install python3.6 -y
fi