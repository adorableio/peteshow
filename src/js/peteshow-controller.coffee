rules   = require('./peteshow-rules')

module.exports =
  fillOutForms: =>
    console.log('PeteshowController::fillOutForms')

    $('input:checkbox').each(@fillCheckboxes)
    $('input:radio').each(@fillRadioButtons)
    $('select').each(@fillSelectBoxes)

    # force rules (for hidden fields)
    # for element, value of _options.force
    #   $(element)
    #     .filterFields()
    #     .val(if $.isFunction(v) then v() else v)

    #   $(element).blur() if (_options.blur)

    # # fill out fields with rules
    # for element, v of rules
    #   $(element)
    #     .filter(':visible')
    #     .filterFields()
    #     .val(if $.isFunction(v) then v() else v)

    #   $(element).blur() if (_options.blur)

    # # special rules
    # _options.special()

    # # localstorage functionality
    # reuseLocalStorage()

  fillOutFormsAndSubmit: -> console.log('PeteshowController::fillOutFormsAndSubmit')

  fillCheckboxes: (i, v) ->
    console.log i, v

  fillRadioButtons: (i, v) ->
    console.log i, v
    # $(radios[Math.floor(Math.random() * radios.length)])

  fillSelectBoxes: (i, v) ->
    console.log i, v
    #   .filterFields()
    #   .prop('checked', true)
    #   .change()
