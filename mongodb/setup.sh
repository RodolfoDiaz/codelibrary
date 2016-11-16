echo "Installing MongoDB - https://community.c9.io/t/setting-up-mongodb/1717"
sudo apt-get install -y mongodb-org
echo "Running MongoDB on a Cloud9 workspace"
mkdir data
echo 'mongod --bind_ip=$IP --dbpath=data --nojournal --rest "$@"' > mongod
chmod a+x mongod
echo "You can start mongodb by running the mongod script"