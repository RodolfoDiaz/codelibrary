(function() {
    'use strict';
    var express = require('express');

    var routes = function(Book) {
        var bookRouter = express.Router();
        var bookController = require('../controllers/bookController')(Book);

        bookRouter.route('/')
            .post(bookController.post)
            .get(bookController.get);

        bookRouter.use('/:bookId', function(req, res, next) {
            Book.findById(req.params.bookId, function(err, book) {
                if (err) {
                    res.status(500).send(err);
                } else if (book) {
                    req.book = book;
                    next();
                } else {
                    res.status(404).send('no book found!');
                }
            });
        });

        bookRouter.route('/:bookId')
            //support a query by ID, for example: http://localhost:8080/api/books/58a747202ba0ef40e1188b2b
            .get(function(req, res) {
                // Get an specific book by _id
                //res.json(req.book);
                var returnBook = req.book.toJSON();
                returnBook.links = {};
                var newLink = 'http://' + req.headers.host + '/api/books?genre=' + returnBook.genre;
                returnBook.links.FilterByThisGenre = newLink.replace(' ', '%20');
                res.json(returnBook);
            })
            .put(function(req, res) {
                // Change/update an specific book by _id (replaces all attributes)
                req.book.title = req.body.title;
                req.book.author = req.body.author;
                req.book.genre = req.body.genre;
                req.book.read = req.body.read;
                req.book.save(function(err) {
                    if (err) {
                        res.status(500).send(err);
                    } else {
                        res.json(req.book);
                    }
                });
            })
            .patch(function(req, res) {
                // Change/update an attribute from an specific book by _id
                if (req.body._id) {
                    delete req.body._id;
                }
                for (var key in req.body) {
                    if (req.body.hasOwnProperty(key)) {
                        req.book[key] = req.body[key];
                    }
                }
                req.book.save(function(err) {
                    if (err) {
                        res.status(500).send(err);
                    } else {
                        res.json(req.book);
                    }
                });
            })
            .delete(function(req, res) {
                req.book.remove(function(err) {
                    if (err) {
                        res.status(500).send(err);
                    } else {
                        res.status(204).send('Removed');
                    }
                });
            });

        return bookRouter;
    };

    module.exports = routes;

}());