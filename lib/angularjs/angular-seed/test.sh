cd angular-seed
# mv karma.conf.js karma.conf.js.bak
# In '/angular-seed/karma.conf.js' 
# 1- inside browsers section, change: ['Chrome'] to be: browsers: ['PhantomJS']
# 2- inside plugins section, add the following: 'karma-phantomjs-launcher',
npm install karma-phantomjs-launcher --save-dev
npm install phantomjs-prebuilt --save-dev
npm test