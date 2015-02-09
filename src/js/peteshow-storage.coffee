# LocalStorage should fallback to userData when not available
store = require('store')
cs    = require('calmsoul')
_     = require('lodash')
Session = require('./models/session')

unless store.get('peteshow')
  store.set('peteshow', {})

module.exports =
  get: (key) ->
    cs.log('PeteshowStorage::get')
    data = store.get('peteshow')
    return unless data
    return data[key] if key?
    data

  set: (key, data) ->
    cs.log('PeteshowStorage::set')
    if key == 'sessions'
      cs.info('PeteshowStorage::set [Error] Please use addSession() to set a session')
      return
    storedData = @get()
    console.log key, data

    switch typeof data
      when "array"
        console.log "array"
        storedData[key] = [] unless storedData[key]?
        _data = _.merge(storedData[key], data)
      when "object"
        console.log "object"
        storedData[key] = {} unless storedData[key]?
        _data = _.merge(storedData[key], data)
      else
        console.log "else"
        _data = data

    storedData[key] = _data
    store.set('peteshow', storedData)

  sessions: ->
    sessions = @get('sessions') || []

  addSession: (data) ->
    data = {sessions: @sessions()}
    data.sessions.push(new Session(data))
    @set('peteshow', data)


  clear: ->
    cs.log('PeteshowStorage::clear')
    store.remove('peteshow')

