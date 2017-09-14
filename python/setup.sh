if [ "$(uname)" == "Darwin" ]; then
    echo "Install Python and pip in macOS"
    brew install python
    brew install python3
    sudo easy_install pip
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Python in Linux"
    sudo apt-get update
    sudo apt-get install python -y
    sudo apt-get install python3 -y
fi