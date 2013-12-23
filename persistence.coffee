Promise = require("bluebird")
request = require('request')

CONFIG =
  HOST: '127.0.0.1:5984'
  DB_NAME: 'whatoss'

exports.initialize = ->
  findOrCreateDb().then(->
    loadDesignDocument('projects')
  )

findOrCreateDb = ->
  deferred = Promise.defer()

  request.put({json: true, uri: "http://#{CONFIG.HOST}/#{CONFIG.DB_NAME}"}, (err, request, body)->
    if err?
      deferred.reject(err)
    else
      if body.error?
        if body.error is 'file_exists'
          console.log "Using pre-existing DB #{CONFIG.DB_NAME}"
          deferred.resolve()
        else
          deferred.reject(body.error)
      else
        console.log "Created database #{CONFIG.DB_NAME}"
        deferred.resolve()
  )

  return deferred.promise

loadDesignDocument = (name) ->
  deferred = Promise.defer()

  extend = require('util')._extend
  document = extend({}, require("./design_documents/#{name}"))

  convertFunctionsToStrings(document)

  request.put({
    json: true
    uri: "http://#{CONFIG.HOST}/#{CONFIG.DB_NAME}/_design/#{name}"
    body: JSON.stringify(document)
  }, (err, request, body)->
    console.log body
    deferred.resolve()
  )

  return deferred.promise

convertFunctionsToStrings = (document) ->
  for viewName, functions of document.views
    for action, fn of functions
      document.views[viewName][action] = fn.toString()
