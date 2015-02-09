_     = require('lodash')
cs    = require('calmsoul')
store = require('./storage')

class DeweyController
  view: null
  session: null

  init: (view) ->
    cs.log('DeweyController::Constructor')
    @view = view
    @resetSession(Dewey.options.resets)

  setSession: (id) ->
    @session = id

  saveSession: -> return

  resetSession: (resets) ->
    @view.setSession("new") if @hasReset(resets)

  getSessionStorage: (id) ->
    sessions = store.get('sessions') || {saved:null}
    _.find(sessions.saved, {id: id})

  hasReset: (resets) ->
    cs.log('DeweyController::checkReset', resets)
    selectors = resets.join(',')
    $(selectors).length > 0

  fillOutForms: =>
    cs.log('DeweyController::fillOutForms')

    session = @getSessionStorage(@session) if @session != 'new' && @session != 'last'

    inputs     = @fillInputs(session)
    radios     = @fillRadioButtons(session)
    checkboxes = @fillCheckboxes(session)
    selects    = @fillSelectBoxes(session)

  fillOutFormsAndSubmit: =>
    cs.log('DeweyController::fillOutFormsAndSubmit')
    @fillOutForms()
    $(Dewey.options.form).submit()
    $('form[name*=registration], .simple_form').submit()
    $('form').last().submit()

  fillInputs: ->
    cs.log('DeweyController::fillInputs')
    saved = Dewey.options.saved

    elements = []

    for element, rule of Dewey.options.rules
      value = if _.isFunction(rule) then rule() else rule

      # Well, we've made it this far. Let's go ahead and fill this form out
      $(element).each (i, el) ->
        # Restore saved fields values from the saved option
        key = _.findKey(saved, (v, k) -> $(el).is(k))
        if key != undefined
          return $(el).val(saved[key])

        return if $(el).is(':checkbox')
        ignored = $(el).is(Dewey.options.ignore.toString())
        return if ignored
        $(el).val(value)

      elementHash = {}
      elementHash[element] = value
      elements.push(elementHash)
    return elements


  _uniqueInputNames: ($inputs) ->
    return false if $inputs.length < 0
    _.uniq($inputs.map (i, $input) -> $input.name)

  fillCheckboxes: (session) ->
    cs.log('DeweyController::fillCheckboxes')

    for el in $('input:checkbox')
      # boolean = !!Dewey.random.number(1)
      $(el)
        .prop('checked', true)
        .change()

  fillRadioButtons: (session) ->
    cs.log('DeweyController::fillRadioButtons')
    return unless inputNames = @_uniqueInputNames($('input:radio'))

    for name in inputNames
      $els = $("input:radio[name='#{name}']")
      randomIndex = Math.floor(Math.random() * $els.length)
      $el = $els.eq(randomIndex)
      $el
        .prop('checked', true)
        .change()

  fillSelectBoxes: (session) ->
    cs.log('DeweyController::fillSelectBoxes')

    for el in $('select')
      selectOptions = $.makeArray($(el).find('option'))
      values = selectOptions.map (el) -> $(el).val()
      values = _.difference(values, Dewey.options.filters)

      randomIndex = Math.floor(Math.random() * values.length)
      value = values[randomIndex]

      $(el)
        .val(value)
        .change()

module.exports = DeweyController
