if [ "$(uname)" == "Darwin" ]; then
    echo "Install Python and pip in macOS using Homebrew"
    brew install python
    # Installing Packages - https://packaging.python.org/tutorials/installing-packages/
    python -m pip install --upgrade pip setuptools wheel
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Python in Linux"
    sudo apt-get update
    sudo apt-get install python -y
fi