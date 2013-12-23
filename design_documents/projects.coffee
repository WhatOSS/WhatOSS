module.exports =
  _id: "_design/projects",
  views:
    all:
      map: (doc) ->
        emit(doc._id, doc._rev)
