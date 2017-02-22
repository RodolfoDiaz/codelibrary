(function() {
    'use strict';
    var bookController = function(Book) {
        var post = function(req, res) {
            // Create a new book
            var book = new Book(req.body);
            book.save();
            res.status(201).send(book);
        };

        var get = function(req, res) {
            // Get all books
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
        };

        return {
            post: post,
            get: get
        };
    };

    module.exports = bookController;

}());