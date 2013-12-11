express = require('express')
http = require('http')
hbs = require('express-hbs')

exports.start = (port, callback)->
  app = express()

  app.engine('hbs', hbs.express3({
    partialsDir: __dirname + '/views/partials',
    contentHelperName: 'content',
  }))
  app.set('view engine', 'hbs')
  app.set('views', __dirname + '/views')

  app.get "/", require('./routes/index')

  server = http.createServer(app).listen port, (err) ->
    callback err, server
