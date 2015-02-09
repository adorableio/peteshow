# LocalStorage should fallback to userData when not available
store = require('store')
cs    = require('calmsoul')
_     = require('lodash')
Session = require('./models/session')

unless store.get('dewey')
  store.set('dewey', {})

module.exports =
  get: (key) ->
    cs.log('DeweyStorage::get')
    data = store.get('dewey') || {}
    return unless data
    return data[key] if key?
    data

  set: (key, data) ->
    cs.log('DeweyStorage::set')
    if key == 'sessions'
      cs.info('DeweyStorage::set [Error] Please use addSession() to set a session')
      return
    storedData = @get()

    switch typeof data
      when "array"
        storedData[key] = [] unless storedData[key]?
        _data = _.merge(storedData[key], data)

      when "object"
        storedData[key] = {} unless storedData[key]?
        _data = _.merge(storedData[key], data)

      else
        _data = data

    storedData[key] = _data
    store.set('dewey', storedData)

  sessions: ->
    sessions = @get('sessions') || []

  addSession: (data) ->
    data = {sessions: @sessions()}
    data.sessions.push(new Session(data))
    @set('dewey', data)

  activeSession: (id) ->
    if id?
      @set("active_session", id)
    @get('active_session')

  lastSession: ->
    @get("last_session")

  getAll: -> store.getAll().dewey

  clear: ->
    cs.log('DeweyStorage::clear')
    store.remove('dewey')

