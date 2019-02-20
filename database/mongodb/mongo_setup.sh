if [ "$(uname)" == "Darwin" ]; then
    echo "Install MongoDB Community Edition on OS X"
    # https://docs.mongodb.com/master/tutorial/install-mongodb-on-os-x/
    if [ "$1" == "u" ]; then
        brew uninstall mongodb
        # remove python@2 and all packages installed by pip
        pip2 freeze | xargs pip2 uninstall -y
        brew uninstall python@2
        rm /usr/local/bin/pip
        rm -rf /usr/local/lib/python2.7
        # uninstalling dependecies for python
        brew uninstall sqlite
        brew uninstall gdbm
        brew uninstall readline
        brew uninstall openssl
        # Create a database folder
        cd ~
        rm -rf mongoData
        rm ~/mongod
    fi

    if [ "$1" == "i" ]; then
        brew update
        brew install mongodb
        # Create a database folder
        cd ~
        mkdir mongoData
        echo 'mongod --dbpath=mongoData --nojournal' > mongod
        chmod a+x mongod
        # You can start MongoDB server by running the $ ./mongod script, to access a shell prompt use: $ mongo
        # To have launchd start mongodb now and restart at login:
        #   brew services start mongodb
        # Or, if you don't want/need a background service you can just run:
        #   mongod --config /usr/local/etc/mongod.conf
    fi
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install MongoDB Community Edition on Linux"
    # https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
    # 1- Import the public key used by the package management system
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
    # 2- Create a list file for MongoDB.
    # Run command: lsb_release -a to check Ubuntu version. For Ubuntu 18.04 you use the following:
    echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
    # 3- Reload local package database.
    sudo apt update
    # 4- Install the latest version of MongoDB.
    sudo apt install -y mongodb-org
    # Default configuration file is stored at: /etc/mongod.conf
    # 5- Start MongoDB.
    sudo service mongod start
    # 6- Stop MongoDB.
    echo "To stop MongoDB service: sudo service mongod stop"
    #sudo service mongod stop
    # To access a shell prompt use: $ mongo
fi