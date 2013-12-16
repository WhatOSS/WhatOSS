express = require('express')
http = require('http')
hbs = require('express-hbs')
Persistence = require('./persistence')

exports.start = (port, callback)->
  app = express()

  Persistence.initialize()

  app.engine('hbs', hbs.express3({
    partialsDir: __dirname + '/views/partials',
    contentHelperName: 'content',
  }))
  app.set('view engine', 'hbs')
  app.set('views', __dirname + '/views')

  app.get "/", require('./routes/index')

  server = http.createServer(app).listen port, (err) ->
    callback err, server
