npm install sails -g
sails new test-project
cd test-project
sails lift

# You need to configure Sails to use the IP and port as specified in 
# the Cloud9 environment variables $IP and $PORT.
# Change your config/env/development.js
#
#module.exports = {
#  port: process.env.PORT,
#  host: process.env.IP
#};