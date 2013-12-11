require('coffee-script');
var server = require('./server');

server.start(3005, function(err, server) {
  if (err) {
    console.error(err);
    process.exit(1);
  } else {
    console.log('Express server listening on ' + server.address().port);
  }
});
