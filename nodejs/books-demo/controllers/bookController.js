(function () {
  'use strict';
  var bookController = function (Book) {

    /**
     * post - Create a new book
     *
     * @param  {Object} req request object
     * @param  {Object} res response object
     * @return {void}
     */
    var post = function (req, res) {
      var book = new Book(req.body);

      if (!req.body.title) {
        res.status(400);
        res.send('Title is required');
      } else {
        book.save();
        res.status(201);
        res.send(book);
      }
    };

    /**
     * get - Get all books
     *
     * @param  {Object} req request object
     * @param  {Object} res response object
     * @return {void}
     */
    var get = function (req, res) {
      var query = {};
      // support of queries such as: http://localhost:8080/api/books?genre=Historical%20Fiction
      if (req.query.genre) {
        query.genre = req.query.genre;
      }
      if (req.query.author) {
        query.author = req.query.author;
      }

      Book.find(query, function (err, books) {
        if (err) {
          res.status(500).send(err);
        } else {
          var returnBooks = [];
          books.forEach(function (element, index, array) {
            var newBook = element.toJSON();
            newBook.links = {};
            newBook.links.self = 'http://' + req.headers.host + '/api/books/' + newBook._id;
            returnBooks.push(newBook);
          });
          res.json(returnBooks);
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
