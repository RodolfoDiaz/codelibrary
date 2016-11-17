echo "Installing MongoDB"
sudo apt-get install -y mongodb-org
echo "Running MongoDB on a Cloud9 workspace"
mkdir data
echo 'mongod --bind_ip=$IP --dbpath=data --nojournal --rest "$@"' > mongod
chmod a+x mongod
echo "You can start mongodb by running the mongod script"
echo "To access a shell prompt for the above MongoDB run the following.   $ mongo"