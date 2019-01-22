if [ "$(uname)" == "Darwin" ]; then
    # Reference: https://docs.brew.sh/Homebrew-and-Python
    echo "Install Python and pip in macOS using Homebrew"
    brew install python@2
    brew install python
    # Installing Packages - https://packaging.python.org/tutorials/installing-packages/
    echo "Python 2 - Upgrade all outdated packages (to list them: pip list --outdated)"
    pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
    echo "Python 3 - Upgrade all outdated packages (to list them: pip3 list --outdated)"
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Python in Linux"
    sudo apt-get update
    sudo apt-get install python -y
fi