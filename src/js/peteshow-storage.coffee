# LocalStorage should fallback to userData when not available
store = require('store')

module.exports =
  get: (key) ->
    console.log('PeteshowStorage::get')
    data = store.get('peteshow')
    return data[key] if key?
    data

  set: (key, data) ->
    console.log('PeteshowStorage::set')
    _data = store.get('peteshow') || {}
    _data[key] = data
    store.set('peteshow', _data)
