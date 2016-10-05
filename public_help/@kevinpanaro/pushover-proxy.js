'use strict';

var http    = require('http');
var request = require('request');
var extend  = require('xtend');

var config = {
  forwardUrl: 'http://localhost:8123',
  listenPort: 8120
};

function forwardRequest(req, res) {
  var url_parts = require('url').parse(req.url, true);

  req.params = url_parts.query;

  console.log(req.method, req.url);

  var apiPassword = req.params.api_password || '';
  var method = req.params.method || 'post';
  var contentType = req.params.content_type || 'application/json';
  var data = req.params.data;

  delete req.params.api_password;
  delete req.params.method;
  delete req.params.content_type;
  delete req.params.data;

  if (data) {
    try {
      data = JSON.parse(data);
    } catch (err) {
      data = {}
    }
  }

  data = extend(data, req.params);

  request({
    method: method.toUpperCase(),
    url: config.forwardUrl + url_parts.pathname,
    headers: {
      'x-ha-access': apiPassword,
      'content-type': contentType
    },
    body: JSON.stringify(data)
  },
  function(err, response, body) {
    if (err) {
      res.end();
      return console.error(err);
    }

    res.writeHead(response.statusCode, response.headers);
    res.end(body);
  });
}

http.createServer(forwardRequest).listen(config.listenPort, function() {
  console.log('Forwarding proxy listening on: http://localhost:%s', config.listenPort);
});
