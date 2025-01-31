'use strict';

var fs = require('fs');
var formatUrl = require('url').format;
var argv = require('./argv');
var through2 = require('through2');
var parse = require('url').parse;
var elasticsearch = require('elasticsearch');
var Client = elasticsearch.Client;
var NoConnections = elasticsearch.errors.NoConnections;
var RequestTimeout = elasticsearch.errors.RequestTimeout;

var url = argv.url;
if (!url) {
  var host = String(argv.host);
  var proto = host.includes('//') ? '' : '//';
  var parsed = parse(proto + host, false, true);

  url = formatUrl({
    hostname: parsed.hostname,
    port: parsed.port,
  });
}

var makeUseable;
var usable = new Promise(function (resolve) {
  makeUseable = resolve;
});

var ms = 5000;
console.log("Reading Bearer Token from /etc/secret-volume/token");
var thetoken = fs.readFileSync("/etc/secret-volume/token").toString(); 
console.log("Token Read");
var authheader = 'Bearer ' + thetoken;
console.log(authheader);
var client = module.exports = new Client({
  log: {
    type: 'stream',
    level: 'trace',
    stream: through2(function (chunk, enc, cb) {
      usable.then(function () {
        process.stdout.write(chunk, enc);
        cb();
      });
    })
  },
  host: url,
  name: 'makelogs',
  headers: {'Authorization:': authheader }
});

client.usable = usable;

client.ping({
  requestTimeout: ms
})
.then(function () {
  makeUseable();
})
.catch(function (err) {
  var notAlive = err instanceof NoConnections;
  var timeout = err instanceof RequestTimeout;

  if (notAlive || timeout) {
    console.error('Unable to connect to elasticsearch at %s within %d seconds', host, ms / 1000);
  } else {
    console.log('unknown ping error', err);
  }

  client.close();
  // prevent the promise from ever resolving or rejecting
  return new Promise(() => {});
});
