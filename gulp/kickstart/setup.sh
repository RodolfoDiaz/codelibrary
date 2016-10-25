npm install -g gulpjs/gulp-cli bower
npm init
if ! [ -f .bowerrc ]; then printf "{\n  \""directory"\": \""app/bower_components"\" \n}" > .bowerrc; fi
bower init
npm install gulp gulp-clean jshint gulp-jshint gulp-uglify gulp-minify-css gulp-connect --save-dev
bower install angular angular-animate angular-route jquery animate.css bootstrap font-awesome --save
