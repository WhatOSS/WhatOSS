express = require('express')
http = require('http')
hbs = require('express-hbs')

exports.start = (port=3005)->
  app = express()

  app.engine('hbs', hbs.express3({
    partialsDir: __dirname + '/views/partials',
    contentHelperName: 'content',
  }))
  app.set('view engine', 'hbs')
  app.set('views', __dirname + '/views')

  app.get "/", require('./routes/index')

  server = http.createServer(app).listen port, (err) ->
    if err
      console.error err
      process.exit 1
    else
      console.log "Express server listening on port " + port

