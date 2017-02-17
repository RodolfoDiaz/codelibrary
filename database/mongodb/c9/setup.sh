# Install MongoDB Community Edition on Ubuntu
# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
# 1- Import the public key used by the package management system
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
# 2- Create a list file for MongoDB.
# Run command: lsb_release -a to check Ubuntu version. For Ubuntu 14.04 you use the following:
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
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