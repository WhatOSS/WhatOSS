CONFIG =
  HOST: '127.0.0.1:5984'
  DB_NAME: 'whatoss'

Promise = require("bluebird")
_ = require('underscore')

exports.initialize = ->
  findOrCreateDb().then(->
    loadDesignDocument('projects')
  )

exports.nano = ->
  require('nano')("http://#{CONFIG.HOST}")

exports.nanoDb = ->
  nanoDb = exports.nano().use(CONFIG.DB_NAME)
  return Promise.promisifyAll(nanoDb)

findOrCreateDb = ->
  deferred = Promise.defer()
  nano = exports.nano()

  nano.db.create(CONFIG.DB_NAME, (err, body)->
    if err?
      if err.message is 'The database could not be created, the file already exists.'
        deferred.resolve()
      else
        deferred.reject(body.error)
    else
      deferred.resolve()
  )

  return deferred.promise

exports.dropDb = ->
  deferred = Promise.defer()

  nano = exports.nano()
  nano.db.destroy(CONFIG.DB_NAME, (err, body) ->
    if err?
      deferred.reject(err)
    else
      deferred.resolve()
  )

  return deferred.promise

loadDesignDocument = (name) ->
  deferred = Promise.defer()
  nanoDb = exports.nanoDb()

  document = _.extend({}, require("./design_documents/#{name}"))

  convertFunctionsToStrings(document)

  nanoDb.get("_design/#{name}", (err, body) ->
    if !err?
      _rev = body._rev
      delete body._rev

      if _.isEqual(body, document)
        return deferred.resolve()
      else
        document._rev = _rev

    nanoDb.insertAsync(document).then(->
      deferred.resolve()
    ).catch((err)->
      deferred.reject(err)
    )
  )

  return deferred.promise

convertFunctionsToStrings = (document) ->
  for viewName, functions of document.views
    for action, fn of functions
      document.views[viewName][action] = fn.toString()
