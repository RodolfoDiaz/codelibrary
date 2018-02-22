/* IMDB API resources:
    http://www.theimdbapi.org
    http://www.omdbapi.com
    https://www.npmjs.com/package/imdb-api
*/

function getMovieByNameURL(titleText, yearText) {
  var title = findAndReplace(titleText, ' ', '+');
  var year = yearText;
  var url = 'https://theimdbapi.org/api/find/movie?title=' + title;
  if (year) {
    url = url + '&year=' + year;
  }
  console.log('GET', url);
  return url;
}

function getMovieByIdURL(movie_id) {
  var url = 'https://theimdbapi.org/api/movie?movie_id=' + movie_id;
  console.log('GET', url);
  return url;
}

var getJSON = function(url, callback) {
  var xhr = new XMLHttpRequest();
  xhr.open('GET', url, true);
  xhr.responseType = 'json';
  xhr.onload = function() {
    var status = xhr.status;
    if (status === 200) {
      callback(null, xhr.response);
    }
    else {
      callback(status, xhr.response);
    }
  };
  xhr.send();
};

function findAndReplace(string, target, replacement) {
  var i = 0,
    length = string.length;
  for (i; i < length; i++) {
    string = string.replace(target, replacement);
  }
  return string;
}
