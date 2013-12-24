module.exports =
  _id: "_design/projects",
  views:
    all:
      map: (doc) ->
        if doc.type? and doc.type is 'project'
          emit(doc._id, doc)
