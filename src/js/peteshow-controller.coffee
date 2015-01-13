_  = require('lodash')
cs = require('calmsoul')

class PeteshowController
  fillOutForms: =>
    cs.log('PeteshowController::fillOutForms')

    @fillInputs()
    @fillRadioButtons($('input:radio'))
    @fillCheckboxes($('input:checkbox'))
    @fillSelectBoxes($('select'))

  fillOutFormsAndSubmit: =>
    cs.log('PeteshowController::fillOutFormsAndSubmit')
    @fillOutForms()
    $(Peteshow.options.form).submit()
    $('form[name*=registration], .simple_form').submit()
    $('form').last().submit()

  fillInputs: ->
    cs.log('PeteshowController::fillInputs')
    for element, rule of Peteshow.options.rules
      value = if _.isFunction(rule) then rule() else rule
      $(element).each (i, el) ->
        return if $(el).is(':checkbox')
        ignored = $(el).is(Peteshow.options.ignore.toString())
        return if ignored
        $(el).val(value)

  _uniqueInputNames: ($inputs) ->
    return false if $inputs.length < 0
    _.uniq($inputs.map (i, $input) -> $input.name)

  fillCheckboxes: ($inputs) ->
    cs.log('PeteshowController::fillCheckboxes')

    for el in $inputs
      # boolean = !!Peteshow.random.number(1)
      $(el)
        .prop('checked', true)
        .change()

  fillRadioButtons: ($inputs) ->
    cs.log('PeteshowController::fillRadioButtons')
    return unless inputNames = @_uniqueInputNames($inputs)

    for name in inputNames
      $els = $("input:radio[name='#{name}']")
      randomIndex = Math.floor(Math.random() * $els.length)
      $el = $els.eq(randomIndex)
      $el
        .prop('checked', true)
        .change()

  fillSelectBoxes: ($inputs) ->
    cs.log('PeteshowController::fillSelectBoxes')

    for el in $inputs
      $selectOptions = $(el).find('option')

      filters = Peteshow.options.filters
        .toString()
        .replace(new RegExp(',', 'g'), '|')

      filteredOptions = []

      $selectOptions.each (el) ->
        value = $(this).val()
        filteredOptions.push value if not value.match(filters)? and value isnt ""

      randomIndex = Math.floor(Math.random() * filteredOptions.length)

      $(el)
        .val(filteredOptions[randomIndex])
        .change()

module.exports = new PeteshowController()
