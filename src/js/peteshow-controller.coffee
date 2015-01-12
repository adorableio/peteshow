_ = require('underscore')

class PeteshowController
  fillOutForms: =>
    console.log('PeteshowController::fillOutForms')

    @fillInputs()
    @fillRadioButtons($('input:radio'))

  fillOutFormsAndSubmit: ->
    console.log('PeteshowController::fillOutFormsAndSubmit')

  fillInputs: ->
    console.log('PeteshowController::fillInputs')
    for element, rule of Peteshow.options.rules
      $(element).val(rule)

  fillCheckboxes: (i, v) ->
    console.log('PeteshowController::fillCheckboxes')
    console.log i, v

  fillRadioButtons: ($radioButtonEls) ->
    console.log('PeteshowController::fillRadioButtons')
    if $radioButtonEls.length > 0
      radioButtonNames = _.uniq($radioButtonEls.map (i, $btn) -> $btn.name)

      for name in radioButtonNames
        $els = $("input:radio[name='#{name}']")
        randomIndex = Math.floor(Math.random() * $els.length)
        $el = $els.eq(randomIndex)
        $el.prop('checked', true)

  fillSelectBoxes: (i, v) ->
    console.log('PeteshowController::fillSelectBoxes')
    console.log i, v

module.exports = new PeteshowController()
