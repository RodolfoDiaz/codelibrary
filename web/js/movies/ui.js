function getMovie() {
    var url = '';
    var searchType = getSearchType();
    if (searchType == 'name') {
        url = getMovieByNameURL(document.getElementById('titleText').value, document.getElementById('yearText').value);
    }
    else {
        url = getMovieByIdURL(document.getElementById('movieIdText').value);
    }
    search(url, searchType);
}

function getSearchType() {
    var e = document.getElementById('searchTypeList');
    return e.options[e.selectedIndex].value;
}

function search(url, searchType) {
    console.log('Search type is by:', searchType);
    document.getElementById("searchResults").style.display = 'none';
    clearFields();
    setSearchButton(true, searchType);
    getJSON(url,
        function(err, data) {
            if (err !== null) {
                document.getElementById('descriptionText').value = err;
            }
            else {
                console.log('Found ' + data.length + ' movies matching the search criteria!');
                var movie = searchType == 'name' ? data[0] : data;
                console.log(movie);
                if (movie) {
                    setFields(movie);
                }
                else {
                    document.getElementById('descriptionText').value = 'Movie not found!';
                }
                if (searchType == 'name') {
                    createFullList(data);
                }
                setSearchButton(false, searchType);
            }
            document.getElementById('searchResults').style.display = 'block';
        });
}

function clearFields() {
    document.getElementById('movieTitle').innerHTML = '';
    document.getElementById('moviesFound').innerHTML = '';
    document.getElementById('movieLink').innerHTML = '';
    document.getElementById('descriptionText').value = '';
    document.getElementById('posterImg').src = '';
    var ul = document.getElementById('fullList');
    while (ul.firstChild) ul.removeChild(ul.firstChild);
}

function setFields(movie) {
    document.getElementById('movieTitle').innerHTML = movie.title + '(' + movie.year + ')';
    document.getElementById('movieLink').href = movie.url.url;
    document.getElementById('movieLink').innerHTML = movie.imdb_id;
    document.getElementById('descriptionText').value = movie.description;
    document.getElementById('posterImg').src = movie.poster.thumb;
}

function setSearchButton(wait, searchType) {
    var buttonName = searchType == 'name' ? 'searchButton' : 'searchIdButton';
    document.getElementById(buttonName).disabled = wait;
    document.getElementById(buttonName).value = wait ? 'Wait...' : 'Search';
}

function createFullList(movies) {
    document.getElementById('moviesFound').innerHTML = movies.length > 0 ? 'More movies found with this search criteria: ' : '';
    var ul = document.getElementById('fullList');

    for (var i = 0, l = movies.length; i < l; ++i) {
        var li = document.createElement('li');
        var nodeText = movies[i].title + ' (' + movies[i].year + ') ';
        nodeText = nodeText + ' - ' + movies[i].url.url;
        li.appendChild(document.createTextNode(nodeText));
        ul.appendChild(li);
    }
}

function selectSearchType() {
    var searchType = getSearchType();
    if (searchType == 'name') {
        document.getElementById('searchByName').style.display = 'block';
        document.getElementById('searchById').style.display = 'none';
        document.getElementById("searchResults").style.display = 'none';
    }
    else if (searchType == 'id') {
        document.getElementById('searchByName').style.display = 'none';
        document.getElementById('searchById').style.display = 'block';
        document.getElementById("searchResults").style.display = 'none';
    }
}
