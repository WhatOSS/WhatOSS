Persistence = require('../persistence')

exports.create = (attributes, callback) ->
  Persistence.db().save(attributes, callback)

exports.get = (id, callback) ->
  Persistence.db().get(id, callback)
