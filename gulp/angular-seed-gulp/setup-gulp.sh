npm install -g gulpjs/gulp-cli bower
cd angular-seed
if ! [ -d ./node_modules ]; then npm init; fi
if ! [ -f .bowerrc ]; then printf "{\n  \""directory"\": \""app/bower_components"\" \n}" > .bowerrc; fi
if ! [ -d ./app/bower_components ]; then bower init; fi
npm install gulp gulp-clean jshint gulp-jshint gulp-uglify gulp-minify-css gulp-connect run-sequence gulp-browserify gulp-concat --save-dev
