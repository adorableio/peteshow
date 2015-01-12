_ = require('underscore')
cs = require('calmsoul')

class PeteshowController
  fillOutForms: =>
    cs.log('PeteshowController::fillOutForms')

    @fillInputs()
    @fillRadioButtons($('input:radio'))

  fillOutFormsAndSubmit: ->
    cs.log('PeteshowController::fillOutFormsAndSubmit')

  fillInputs: ->
    cs.log('PeteshowController::fillInputs')
    for element, rule of Peteshow.options.rules

  fillCheckboxes: (i, v) ->
    cs.log('PeteshowController::fillCheckboxes')
    cs.log i, v

  fillRadioButtons: ($radioButtonEls) ->
    cs.log('PeteshowController::fillRadioButtons')
    if $radioButtonEls.length > 0
      radioButtonNames = _.uniq($radioButtonEls.map (i, $btn) -> $btn.name)

      for name in radioButtonNames
        $els = $("input:radio[name='#{name}']")
        randomIndex = Math.floor(Math.random() * $els.length)
        $el = $els.eq(randomIndex)

  fillSelectBoxes: (i, v) ->
    cs.log('PeteshowController::fillSelectBoxes')
    cs.log i, v

module.exports = new PeteshowController()
