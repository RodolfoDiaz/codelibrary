var express = require('express');
var mongoose = require('mongoose');

var db = mongoose.connect('mongodb://localhost/bookAPI');

var Book = require('./models/bookModel');

var app = express();

const hostname = process.env.IP || "0.0.0.0";
const port = process.env.PORT || 3000;

var bookRouter = express.Router();

bookRouter.route('/books')
    .get(function(req, res) {
        Book.find(function(err, books) {
            if (err)
                res.status(500).send(err);
            else {
                res.json(books);
            }
        });
    });

app.use('/api', bookRouter);

app.get('/', function(req, res) {
    res.send('Welcome to my API :)');
});

app.listen(port, hostname, function() {
    console.log('Listening on ' + hostname + ' and port: ' + port);
    // you should be able to browse to http://localhost:{PORT}
});