if [ "$(uname)" == "Darwin" ]; then
    echo "Install Django package in macOS"
    #sudo easy_install pip
    pip2 install django
    echo "Django version is: "
    python2 -m django --version
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Django package in Linux"
    sudo apt-get update
    sudo -H pip install -U pip
    sudo -H pip install django --upgrade
    echo "Django version is: "
    python -m django --version
fi