(function() {
    'use strict';
    var express = require('express');
    var mongoose = require('mongoose');
    var bodyParser = require('body-parser');

    mongoose.connect('mongodb://localhost/bookAPI');

    var Book = require('./models/bookModel');

    var app = express();

    const hostname = process.env.IP || '0.0.0.0';
    const port = process.env.PORT || 3000;

    app.use(bodyParser.urlencoded({
        extended: true
    }));
    app.use(bodyParser.json());

    var bookRouter = express.Router();

    bookRouter.route('/books')
        .post(function(req, res) {
            var book = new Book(req.body);
            book.save();
            res.status(201).send(book);
        })
        .get(function(req, res) {
            var query = {};
            // support of queries such as: http://localhost:8080/api/books?genre=Historical%20Fiction
            if (req.query.genre) {
                query.genre = req.query.genre;
            }
            if (req.query.author) {
                query.author = req.query.author;
            }

            Book.find(query, function(err, books) {
                if (err) {
                    res.status(500).send(err);
                } else {
                    res.json(books);
                }
            });
        });

    bookRouter.route('/books/:bookId')
        //support a query by ID, for example: http://localhost:8080/api/books/58a747202ba0ef40e1188b2b
        .get(function(req, res) {

            Book.findById(req.params.bookId, function(err, book) {
                if (err) {
                    res.status(500).send(err);
                } else {
                    res.json(book);
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

}());