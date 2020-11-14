if [ "$1" == "" ]; then
    echo "No argurment found.  Use 'i' to install or 'u' to uninstall Python."
fi

if [ "$(uname)" == "Darwin" ]; then
    if [ "$1" == "i" ]; then
        # Reference: https://docs.brew.sh/Homebrew-and-Python
        echo "Install Python 3 and pip in macOS using Homebrew"
        brew install python
        # python 3 simlinks are here: ll /usr/local/bin/py*
        # pip / pip3 / pip3.7 simlinks are here: ll /usr/local/bin/pip*
        # pip packages are located here: ll /usr/local/lib/python3.7

        # Installing Packages - https://packaging.python.org/tutorials/installing-packages/
        pip3 install --upgrade pip setuptools wheel --user
        echo "Python 3 - Upgrade all outdated packages (to list them: pip3 list --outdated)"
        pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U

        # -- Global Packages --
        pip3 install pylint
        pip3 install pylama
        pip3 install autopep8
        pip3 install virtualenv
        # python3 -m virtualenv my_venv_py3
        #
        # CONFIGURATION - VSCODE: 
        # settings.json
        # {
        #    "python.pythonPath": "python3",
        #    "python.linting.pylamaEnabled": true,
        #    "python.linting.pydocstyleEnabled": true,
        #    "python.linting.pycodestyleEnabled": true
        # }
    fi

    if [ "$1" == "u" ]; then
        # remove all packages installed by pip
        pip3 freeze | xargs pip3 uninstall -y
        brew uninstall python
        rm /usr/local/bin/pip
        rm -rf /usr/local/lib/python3.7
        # uninstalling dependecies for python
        brew uninstall sqlite
        brew uninstall gdbm
        brew uninstall readline
        brew uninstall openssl
        brew uninstall xz
    fi
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    if [ "$1" == "i" ]; then
        echo "Install/Updating Python in Linux"
        # -- For Debian derivatives such as Ubuntu
        # apt list --installed | grep python
        # sudo apt update
        # sudo apt install python3-pip -y
        # sudo apt install python3-venv -y
        # -- For Amazon Linux
        # pip3 install --upgrade --user awscli
        # aws --version
        mkdir ~/newproject
        cd ~/newproject
        python3 -m venv my_env
        source my_env/bin/activate
        python -m pip install --upgrade pip setuptools wheel --user
        pip3 install --upgrade pip setuptools wheel --user
        echo "Python 3 - Upgrade all outdated packages (to list them: pip3 list --outdated)"
        pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U
        #pip3 install PIP_MODULE
        deactivate
    fi
fi
