if ! [ ${IP+x} ]; then export IP=localhost; fi
if ! [ ${PORT+x} ]; then export PORT=8080; fi
echo "IP is:" $IP " and PORT is:" $PORT
if [ -d ~/workspace/ ]; then echo "Cloud9"; cd ~/workspace/angularjs/angular-seed; else echo "Not in Cloud9"; fi
rm -rf ./angular-seed
# Clone angular-seed repo and install the necessary packages
git clone https://github.com/angular/angular-seed.git angular-seed
cd angular-seed
npm install
# Configure your app to run in Cloud9
mv package.json package.json.bak
jq '.scripts.start="http-server -a $IP -p $PORT -c-1 ./app"' package.json.bak > package.json
# Run your app
npm start