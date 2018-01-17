if [ "$(uname)" == "Darwin" ]; then
    echo "Install Python and pip in macOS using Homebrew"
    brew install python
    brew install python3
    # Installing Packages - https://packaging.python.org/tutorials/installing-packages/
    python2 -m pip install --upgrade pip setuptools wheel
    python3 -m pip install --upgrade pip setuptools wheel
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Python in Linux"
    sudo apt-get update
    sudo apt-get install python -y
    sudo apt-get install python3 -y
fi