if [ "$(uname)" == "Darwin" ]; then
    if [ "$1" == "i" ]; then
        # Reference: https://docs.brew.sh/Homebrew-and-Python
        echo "Install Python and pip in macOS using Homebrew"
        brew install python@2
        # python 2 simlinks are here: ll /usr/local/bin/py*
        # pip / pip2 / pip2.7 simlinks are here: ll /usr/local/bin/pip*
        # pip packages are located here: ll /usr/local/lib/python2.7

        # Installing Packages - https://packaging.python.org/tutorials/installing-packages/
        pip install --upgrade pip setuptools wheel
        echo "Python 2 - Upgrade all outdated packages (to list them: pip list --outdated)"
        pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U

        # -- Global Packages --
        # pip2 install pylint
        # pip2 install autopep8
        # pip2 install virtualenv
        # python2 -m virtualenv my_venv_py2
    fi

    if [ "$1" == "u" ]; then
        brew uninstall python@2
        # remove all packages installed by pip
        # pip freeze | xargs pip uninstall -y
        #rm /usr/local/bin/pip
        rm -rf /usr/local/lib/python2.7
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