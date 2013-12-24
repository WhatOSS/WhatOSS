assert = require('chai').assert
Persistence = require('../../persistence')

suite('_design/projects/_view')

test('/all returns all projects', (done) ->
  attributes =
    name: 'diorama'

  nanoDb = Persistence.nanoDb()

  nanoDb.insertAsync(attributes).then((body)->
    nanoDb.viewAsync('projects', 'all')
  ).spread((returnedProjects) ->
    try
      assert.strictEqual returnedProjects.total_rows, 1,
        "Expected the one created record to be returned"

      returnedProject = returnedProjects.rows[0]
      assert.strictEqual returnedProject.value.name, attributes.name,
        "Expected the queried project to have the correct attributes"
      done()
    catch e
      done(e)
  ).error(->
    done(new Error(err))
  )
)
