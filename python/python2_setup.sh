if [ "$(uname)" == "Darwin" ]; then
    if [ "$1" == "i" ]; then
        # Reference: https://docs.brew.sh/Homebrew-and-Python
        echo "Install Python 2 and pip in macOS using Homebrew"
        brew install python@2
        # python 2 simlinks are here: ll /usr/local/bin/py*
        # pip / pip2 / pip2.7 simlinks are here: ll /usr/local/bin/pip*
        # pip packages are located here: ll /usr/local/lib/python2.7

        # Installing Packages - https://packaging.python.org/tutorials/installing-packages/
        pip2 install --upgrade pip setuptools wheel --user
        echo "Python 2 - Upgrade all outdated packages (to list them: pip2 list --outdated)"
        pip2 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip2 install -U

        # -- Global Packages --
        pip2 install pylint
        pip2 install pylama
        pip2 install autopep8
        pip2 install virtualenv
        # python2 -m virtualenv my_venv_py2
    fi

    if [ "$1" == "u" ]; then
        # remove all packages installed by pip
        pip2 freeze | xargs pip2 uninstall -y
        brew uninstall python@2
        rm /usr/local/bin/pip
        rm -rf /usr/local/lib/python2.7
        # uninstalling dependecies for python
        brew uninstall sqlite
        brew uninstall gdbm
        brew uninstall readline
        brew uninstall openssl
    fi
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    if [ "$1" == "i" ]; then
        echo "Install Python in Linux"
        # Install Python 2
        sudo apt install python-pip -y
        sudo pip install virtualenv
        mkdir ~/newproject_py2
        cd ~/newproject_py2
        virtualenv my_env_py2
        source my_env_py2/bin/activate
        python -m pip install --upgrade pip setuptools wheel
        #pip2 install PIP_MODULE
        deactivate
    fi
fi
