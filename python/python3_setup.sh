if [ "$(uname)" == "Darwin" ]; then
    if [ "$1" == "i" ]; then
        # Reference: https://docs.brew.sh/Homebrew-and-Python
        echo "Install Python 3 and pip in macOS using Homebrew"
        brew install python
        # python 3 simlinks are here: ll /usr/local/bin/py*
        # pip / pip3 / pip3.7 simlinks are here: ll /usr/local/bin/pip*
        # pip packages are located here: ll /usr/local/lib/python3.7

        # Installing Packages - https://packaging.python.org/tutorials/installing-packages/
        pip3 install --upgrade pip setuptools wheel
        echo "Python 3 - Upgrade all outdated packages (to list them: pip3 list --outdated)"
        pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U

        # -- Global Packages --
        pip3 install pylint
        pip3 install autopep8
        pip3 install virtualenv
        # python3 -m virtualenv my_venv_py3
    fi

    if [ "$1" == "u" ]; then
        # remove all packages installed by pip
        pip3 freeze | xargs pip3 uninstall -y
        brew uninstall python
        rm /usr/local/bin/pip
        rm -rf /usr/local/lib/python3.7
    fi
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    if [ "$1" == "i" ]; then
        echo "Install Python in Linux"
        # Install Python 3
        sudo apt install python3-pip -y
        sudo apt install python3-venv -y
        mkdir ~/newproject
        cd ~/newproject
        python3 -m venv my_env
        source my_env/bin/activate
        python -m pip install --upgrade pip setuptools wheel
        #pip3 install PIP_MODULE
        deactivate
    fi
fi