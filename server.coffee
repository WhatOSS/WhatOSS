express = require('express')
http = require('http')

exports.start = (port=3005)->
  app = express()

  app.get "/", require('./routes/index')

  server = http.createServer(app).listen port, (err) ->
    if err
      console.error err
      process.exit 1
    else
      console.log "Express server listening on port " + port

