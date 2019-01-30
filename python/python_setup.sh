if [ "$(uname)" == "Darwin" ]; then
    # Reference: https://docs.brew.sh/Homebrew-and-Python
    echo "Install Python and pip in macOS using Homebrew"
    brew install python@2
    brew install python
    # Installing Packages - https://packaging.python.org/tutorials/installing-packages/
    pip install --upgrade pip setuptools wheel
    pip3 install --upgrade pip setuptools wheel
    echo "Python 2 - Upgrade all outdated packages (to list them: pip list --outdated)"
    pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
    echo "Python 3 - Upgrade all outdated packages (to list them: pip3 list --outdated)"
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Python in Linux"
    # Start by updating your Ubuntu operating system software packages
    sudo apt update
    sudo apt upgrade
    sudo apt install build-essential dkms linux-headers-$(uname -r)
    sudo apt autoremove -y

    # Install Python 2
    sudo apt install python-pip -y
    sudo pip install virtualenv
    mkdir ~/newproject_py2
    cd ~/newproject_py2
    virtualenv my_env_py2
    source my_env_py2/bin/activate
    python -m pip install --upgrade pip setuptools wheel
    #pip install PIP_MODULE
    deactivate

    # Install Python 3
    sudo apt install python3-pip -y
    sudo apt install python3-venv -y
    mkdir ~/newproject
    cd ~/newproject
    python3 -m venv my_env
    source my_env/bin/activate
    python -m pip install --upgrade pip setuptools wheel
    #pip install PIP_MODULE
    deactivate

fi