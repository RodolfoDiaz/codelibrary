var express = require('express');

var app = express();

const hostname = process.env.IP || "0.0.0.0";
const port = process.env.PORT || 3000;

app.get('/', function(req, res){
  res.send('Welcome to my API :)');
});

app.listen(port, hostname, function(){
  console.log('Listening on ' + hostname + ' and port: ' + port);
  // you should be able to browse to http://localhost:{PORT}
});