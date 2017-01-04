# Introduction to Mongoose for Node.js and MongoDB - https://app.pluralsight.com/library/courses/mongoose-for-nodejs-mongodb/
# Install npm packages necessary
npm install express -g
npm install express-generator -g
if [ -d ./standup/ ]; then rm -rf standup; fi
mkdir standup
express -H ./standup/
cd standup
npm install
npm start