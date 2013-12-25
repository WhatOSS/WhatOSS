express = require('express')
http = require('http')
path = require('path')
hbs = require('express-hbs')
Persistence = require('./persistence')

exports.start = (port, callback)->
  app = express()

  Persistence.initialize().then(->
    app.engine('hbs', hbs.express3({
      partialsDir: __dirname + '/views/partials',
      contentHelperName: 'content',
    }))
    app.set('view engine', 'hbs')
    app.set('views', __dirname + '/views')

    app.get "/", require('./routes/index')

    app.use express.static(path.join(__dirname, "public"))

    server = http.createServer(app).listen port, (err) ->
      callback err, server
  ).error((err) ->
    console.error "Error initializing the app"
    console.error err
    console.error err.stack
  )
