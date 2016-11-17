echo "Installing MongoDB"
echo "Instructions installing on Ubuntu: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "Run command: lsb_release -a to check Ubuntu version.  For Ubuntu 14.04 you use the following:"
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update
sudo apt-get install -y mongodb-org
echo "Default configuration file is stored at: /etc/mongod.conf"
echo "Running MongoDB on a Cloud9 workspace"
mkdir data
echo 'mongod --bind_ip=$IP --dbpath=data --nojournal --rest "$@"' > mongod
chmod a+x mongod
echo "You can start mongodb by running the mongod script"
echo "To access a shell prompt for the above MongoDB run the following.   $ mongo"