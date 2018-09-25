if [ "$(uname)" == "Darwin" ]; then
    echo "Install MongoDB Community Edition on OS X"
    # https://docs.mongodb.com/master/tutorial/install-mongodb-on-os-x/
    brew update
    brew install mongodb
    # Create a database folder
    mkdir data
    echo 'mongod --dbpath=data --nojournal' > mongod
    chmod a+x mongod
    # You can start MongoDB server by running the $ ./mongod script, to access a shell prompt use: $ mongo
    # To have launchd start mongodb now and restart at login:
    #   brew services start mongodb
    # Or, if you don't want/need a background service you can just run:
    #   mongod --config /usr/local/etc/mongod.conf
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install MongoDB Community Edition on Linux"
    # https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
    # 1- Import the public key used by the package management system
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
    # 2- Create a list file for MongoDB.
    # Run command: lsb_release -a to check Ubuntu version. For Ubuntu 14.04 you use the following:
    echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
    # 3- Reload local package database.
    sudo apt-get update
    # 4- Install the MongoDB packages.
    sudo apt-get install -y mongodb-org
    # Default configuration file is stored at: /etc/mongod.conf
    # 5- Create a 'mongod' (mongo daemon) script file for Cloud9 environment.
    mkdir data
    echo 'mongod --bind_ip=$IP --dbpath=data --nojournal' > mongod
    chmod a+x mongod
    # You can start MongoDB server by running the $ ./mongod script, to access a shell prompt use: $ mongo
fi