rules   = require('./peteshow-rules')

module.exports =
  fillOutForms: =>
    console.log('PeteshowController::fillOutForms')

    @fillInputs()
    @fillRadioButtons($('input:radio'))

  fillOutFormsAndSubmit: -> console.log('PeteshowController::fillOutFormsAndSubmit')

  fillInputs: ->
    _rules = _.defaults(Peteshow.options.rules, rules)
    for element, rule of _rules
      $(element).val(rule)

  fillCheckboxes: (i, v) ->
    console.log i, v

  fillRadioButtons: (i, v) ->
    console.log i, v

  fillSelectBoxes: (i, v) ->
    console.log i, v
