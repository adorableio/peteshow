_          = require('underscore')
store      = require('./peteshow-storage')
helpers    = require('./peteshow-helpers')
cs         = require('calmsoul')

cs.set
  "log"   : false
  "debug" : true
  "info"  : true

Peteshow =
  view       : null
  store      : store
  random     : helpers

    emailPrefix : 'test-'
    emailDomain : 'example.com'
    form        : ''
    blur        : false
    cookies     : false

    rules       : require('./peteshow-rules')
    filter      : []
    ignore      : []
    force       : {}
    reuse       : {}
    commands    : ''
    special     : null
    events      : null

  init: (options = {}) ->
    cs.log('Peteshow::init', options)
    @setOptions(options)

    @view.render()

  setOptions: (options = {}) ->
    cs.log('Peteshow::setOptions')


exports = module.exports = window.Peteshow = Peteshow
