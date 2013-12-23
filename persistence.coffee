Promise = require("bluebird")
request = require('request')
_ = require('underscore')

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

  console.log "loading design document #{name}"
  document = _.extend({}, require("./design_documents/#{name}"))

  convertFunctionsToStrings(document)

  request.get({
    json: true
    uri: "http://#{CONFIG.HOST}/#{CONFIG.DB_NAME}/_design/#{name}"
  }, (err, req, body) ->
    if !err? and !body.error?
      _rev = body._rev
      delete body._rev
      console.log "_design/#{name} already exists"

      if _.isEqual(body, document)
        console.log "design document is already up to date"
        return deferred.resolve()
      else
        console.log "document has been modified, overwriting _rev #{_rev}"
        document._rev = _rev

    request.put({
      json: true
      uri: "http://#{CONFIG.HOST}/#{CONFIG.DB_NAME}/_design/#{name}"
      body: JSON.stringify(document)
    }, (err, request, body)->
      console.log body
      deferred.resolve()
    )
  )


  return deferred.promise

convertFunctionsToStrings = (document) ->
  for viewName, functions of document.views
    for action, fn of functions
      document.views[viewName][action] = fn.toString()
