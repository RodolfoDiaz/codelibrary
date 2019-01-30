# https://www.djangoproject.com/
if [ "$(uname)" == "Darwin" ]; then
    echo "Install Django package in macOS"
    # --- The Django 1.11.x series is the last to support Python 2.7. ---
    #pip2 install --upgrade setuptools
    #pip2 install Django==1.11.18
    #pip2 install Django --upgrade
    #python2 -m django --version
    # --- Django 2.0 supports Python 3.4, 3.5, and 3.6. ---
    pip3 install --upgrade pip setuptools wheel
    pip3 install django
    python3 -m django --version
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Django package in Linux"

    # --- The Django 1.11.x series is the last to support Python 2.7. ---
    #sudo apt install python-pip -y
    #sudo pip install virtualenv
    #mkdir ~/newproject_py2
    #cd ~/newproject_py2
    #virtualenv my_env_py2
    #source my_env_py2/bin/activate
    #pip install Django==1.11.18
    #python -m django --version
    #deactivate

    sudo apt install python3-pip -y
    sudo apt install python3-venv -y
    mkdir ~/newproject
    cd ~/newproject
    python3 -m venv my_env
    source my_env/bin/activate
    pip install django
    python -m django --version
    deactivate
fi