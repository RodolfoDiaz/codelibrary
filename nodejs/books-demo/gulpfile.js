(function() {
    'use strict';
    var gulp = require('gulp');
    var nodemon = require('gulp-nodemon');
    var gulpMocha = require('gulp-mocha');
    var env = require('gulp-env');
    //var supertest = require('supertest');
    var jshint = require('gulp-jshint');

    var jsFiles = ['*.js', 'controllers/**/*.js', 'models/**/*.js', 'routes/**/*.js'];

    gulp.task('default', function() {
        nodemon({
                script: 'app.js',
                ext: 'js',
                env: {
                    PORT: 8080
                },
                ignore: ['./node_modules/**']
            })
            .on('restart', function() {
                console.log('Restarting...');
            });
    });

    gulp.task('test', function() {
        env({
            vars: {
                ENV: 'Test'
            }
        });
        gulp.src('tests/*.js', {
                read: false
            })
            .pipe(gulpMocha({
                reporter: 'nyan'
            }));
    });

    gulp.task('style', function() {
        gulp.src(jsFiles)
            .pipe(jshint('.jshintrc'))
            .pipe(jshint.reporter('jshint-stylish', {
                verbose: true
            }));
    });

}());
