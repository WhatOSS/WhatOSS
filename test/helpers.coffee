app = require('../server')
test_server = null

before( (done) ->
  expressApp = app.start 3001, (err, server) ->
    test_server = server
    done()
)

after( (done) ->
  test_server.close (err) ->
    if err?
      console.error err

    done()
)
