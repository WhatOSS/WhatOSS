assert = require('chai').assert
Project = require('../../models/project')

suite('Project')

test('.create persists a project record', (done) ->
  attributes =
    name: 'diorama'

  Project.create(attributes, (err, project) ->
    if err?
      done(err)
    else
      Project.get(project.id, (err, returnedProject) ->
        if err?
          done(err)
        else
          try
            assert.strictEqual returnedProject.name, attributes.name,
              "Expected the queried project to have the correct attributes"
            done()
          catch e
            done(e)

      )
  )
)