rm -rf ./angular-seed
# Clone angular-seed repo and install the necessary packages.
git clone https://github.com/angular/angular-seed.git angular-seed
cd angular-seed
npm install
# Prepare your app to run in Cloud9
mv package.json package.json.bak
jq '.scripts.start="http-server -a $IP -p $PORT"' package.json.bak > package.json
#Run your app.
npm start