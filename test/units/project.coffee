assert = require('chai').assert
request = require('request')
Persistence = require('../../persistence')

suite('_design/projects/_view')

test('/all returns all projects', (done) ->
  attributes =
    name: 'diorama'

  Persistence.query('post', '', body: attributes).then((body)->
    Persistence.query('get', '_design/projects/_view/all/', body._id)
  ).then((returnedProjects) ->
    try
      assert.strictEqual returnedProjects.total_rows, 1,
        "Expected the one created record to be returned"

      returnedProject = returnedProjects.rows[0]
      assert.strictEqual returnedProject.value, attributes.name,
        "Expected the queried project to have the correct attributes"
      done()
    catch e
      done(e)
  ).error(->
    done(new Error(err))
  )
)
