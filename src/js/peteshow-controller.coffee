_ = require('underscore')
rules   = require('./peteshow-rules')

class PeteshowController
  fillOutForms: =>
    console.log('PeteshowController::fillOutForms')
    @fillRadioButtons($('input:radio'))

  fillOutFormsAndSubmit: ->
    console.log('PeteshowController::fillOutFormsAndSubmit')

  fillCheckboxes: (i, v) ->
    console.log i, v

  fillRadioButtons: ($radioButtonEls) ->
    if $radioButtonEls.length > 0
      radioButtonNames = _.uniq($radioButtonEls.map (i, $btn) -> $btn.name)

      for name in radioButtonNames
        $els = $("input:radio[name='#{name}']")
        randomIndex = Math.floor(Math.random() * $els.length)
        $el = $els.eq(randomIndex)
        $el.prop('checked', true)

  fillSelectBoxes: (i, v) ->
    console.log i, v

module.exports = new PeteshowController()
