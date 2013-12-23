app = require('../server')
Persistence = require('../persistence')
test_server = null

before( (done) ->
  expressApp = app.start 3001, (err, server) ->
    test_server = server
    done()
)

afterEach((done)->
  Persistence.dropDb().then(
    Persistence.initialize
  ).then(
    done
  ).error((err)->
    console.error "Error cleaning the database:"
    console.error err
    done(err)
  )
)
  

after( (done) ->
  test_server.close (err) ->
    if err?
      console.error err

    done()
)
