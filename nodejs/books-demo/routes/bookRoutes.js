(function() {
    'use strict';
    var express = require('express');

    var routes = function(Book) {
        var bookRouter = express.Router();

        bookRouter.route('/')
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

        return bookRouter;
    };

    module.exports = routes;

}());