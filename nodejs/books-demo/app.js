(function () {
  'use strict';
  var express = require('express');
  var mongoose = require('mongoose');
  var bodyParser = require('body-parser');

  var db;
  if (process.env.ENV === 'Test') {
    db = mongoose.connect('mongodb://localhost/bookAPI_test');
  } else {
    db = mongoose.connect('mongodb://localhost/bookAPI');
  }

  var Book = require('./models/bookModel');

  var app = express();

  const hostname = process.env.IP || '0.0.0.0';
  const port = process.env.PORT || 3000;

  app.use(bodyParser.urlencoded({
    extended: true
  }));
  app.use(bodyParser.json());

  var bookRouter = require('./routes/bookRoutes')(Book);

  app.use('/api/books', bookRouter);

  app.get('/', function (req, res) {
    res.send('Welcome to my API :)');
  });

  app.listen(port, hostname, function () {
    console.log('Listening on ' + hostname + ' and port: ' + port);
    // you should be able to browse to http://localhost:{PORT}
  });

  module.exports = app;

}());
