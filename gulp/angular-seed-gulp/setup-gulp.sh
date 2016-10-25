npm install -g gulpjs/gulp-cli bower
if ! [ -d ./angular-seed/node_modules ]; then npm init; fi
if ! [ -f .bowerrc ]; then printf "{\n  \""directory"\": \""app/bower_components"\" \n}" > .bowerrc; fi
if ! [ -d ./angular-seed/app/bower_components ]; then bower init; fi
npm install gulp gulp-clean jshint gulp-jshint gulp-uglify gulp-minify-css gulp-connect run-sequence gulp-browserify gulp-concat --save-dev
bower install angular angular-animate angular-route jquery bootstrap font-awesome html5-boilerplate --save
