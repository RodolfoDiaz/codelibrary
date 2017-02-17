# Install MongoDB Community Edition on OS X
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