window._ = _          = require('lodash')
store      = require('./storage')
helpers    = require('./helpers')
cs         = require('calmsoul')
Controller = require('./controller')

cs.set
  "log"   : false
  "debug" : true
  "info"  : true

Dewey =
  controller : null
  view       : null
  store      : store
  random     : helpers.random

  options    : {}
  defaults   :
    emailPrefix: 'test-'
    emailDomain: 'example.com'
    form:        ''
    blur:        false
    cookies:     false

    rules:       require('./rules')
    filters:     ['', 'other', 'select']
    ignore:      []
    force:       {}
    reuse:       {}
    saved:       {}
    commands:    ''
    special:     null
    events:      null
    resets:      []

  init: (options = {}) ->
    cs.log('Dewey::init', options)
    @setOptions(options)

    @s = require('./models/session')
    @controller = new Controller()
    @view = require('./view')
    @view.render()
    @controller.init(@view)

  setOptions: (options = {}) ->
    cs.log('Dewey::setOptions')
    @options = _.merge(@defaults, options)

  open: (active) ->
    cs.log('Dewey::open', active)
    @view.open(active)

  destroy: ->
    cs.log('Dewey::destroy')
    @view.destroy()

  fillOutForms: ->
    cs.log('Dewey::FillOutForms')
    @controller.fillOutForms()

exports = module.exports = window.Dewey = Dewey
