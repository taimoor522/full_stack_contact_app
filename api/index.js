import http from 'http';
import data from './data.js';

const server = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/json' });
    res.end(JSON.stringify(data))
});

server.listen(8888);