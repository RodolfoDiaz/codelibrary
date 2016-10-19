# Configure Karma conf with PhantomJS to run in Cloud9
cd angular-seed
cp karma.conf.js karma.conf.js.bak
# Inside '/angular-seed/karma.conf.js' file:
# -inside browsers section, change: ['Chrome'] to be: ['PhantomJS']
sed -i -e 's/Chrome/PhantomJS/g' karma.conf.js
# -inside plugins section, change: 'karma-chrome-launcher' to be 'karma-phantomjs-launcher'
sed -i -e 's/karma-chrome-launcher/karma-phantomjs-launcher/g' karma.conf.js
npm install phantomjs-prebuilt --save-dev
npm install karma-phantomjs-launcher --save-dev
npm test