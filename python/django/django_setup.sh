# https://www.djangoproject.com/
if [ "$(uname)" == "Darwin" ]; then
    echo "Install Django package in macOS"
    # --- The Django 1.11.x series is the last to support Python 2.7. ---
    #pip2 install --upgrade setuptools
    #pip2 install Django==1.11.9
    # --- Django 2.0 supports Python 3.4, 3.5, and 3.6. ---
    pip3 install --upgrade setuptools
    pip3 install django
    echo "Python 2.7 - Django version is: "
    python2 -m django --version
    echo "Python 3.6 - Django version is: "
    python -m django --version
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Django package in Linux"
    sudo apt-get update
    sudo -H pip install -U pip
    sudo -H pip install django --upgrade
    echo "Django version is: "
    python -m django --version
fi