Promise = require("bluebird")
request = require('request')

CONFIG =
  HOST: '127.0.0.1:5984'
  DB_NAME: 'whatoss'

exports.initialize = ->
  findOrCreateDb()

findOrCreateDb = ->
  deferred = Promise.defer()

  request.put({json: true, uri: "http://#{CONFIG.HOST}/#{CONFIG.DB_NAME}"}, (err, request, body)->
    if err?
      console.error "Error creating/verifying existence of the database"
      console.error err
    else
      if body.error?
        if body.error is 'file_exists'
          console.log "Using pre-existing DB #{CONFIG.DB_NAME}"
          deferred.resolve()
        else
          deferred.reject()
      else
        console.log "Created database #{CONFIG.DB_NAME}"
        deferred.resolve()
  )

  return deferred.promise
