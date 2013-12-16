cradle = require 'cradle'

exports.initialize = ->
  cradle.setup({
    host: 'localhost.couch',
    cache: true,
    raw: false
  })

exports.db = ->
  new(cradle.Connection).database('whatoss')
