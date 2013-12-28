assert = require('chai').assert
Persistence = require('../../persistence')

suite('_design/projects/_view')

test('/all only returns type="project" documents', (done) ->
  projectAttributes =
    name: 'diorama'
    type: 'project'

  nonProjectAttributes =
    name: 'tim'
    type: 'user'

  nanoDb = Persistence.nanoDb()

  nanoDb.insertAsync(projectAttributes).then(->
    nanoDb.insertAsync(nonProjectAttributes)
  ).then(->
    nanoDb.viewAsync('projects', 'all')
  ).spread((returnedProjects) ->
    try
      assert.strictEqual returnedProjects.total_rows, 1,
        "Expected the one created record to be returned"

      returnedProject = returnedProjects.rows[0]
      assert.strictEqual returnedProject.value.name, projectAttributes.name,
        "Expected the queried project to have the correct attributes"
      done()
    catch e
      done(e)
  ).error(->
    done(new Error(err))
  )
)
