var http = require('http');

const hostname = process.env.IP || "0.0.0.0";
const port = process.env.PORT || 3000;

var server = http.createServer((req, res) => {
    res.writeHead(200, {
        'Content-Type': 'text/html'
    });
    res.write('<html><body><h1 style="color:green;">Hello World!</h1></body></html>');
    res.end();
});

server.listen(port, hostname, () => {
    // Below you can see the usage of Back quote or back-tick character,
    // in JavaScript this called Template literals (contain place holders)
    console.log(`Server running at http://${hostname}:${port}/`);
});
