_             = require('lodash')
indexTemplate = require('../templates/index.hbs')
store         = require('./peteshow-storage')
cs            = require('calmsoul')

class PeteshowView
  controller: Peteshow.controller
  _events: {}

  constructor: ->
    cs.log("PeteshowView::init")
    @_position = store.get('position') || {x:0, y:0}
    @_active = store.get('active') || false
    @_events =
      '#fill-out-forms' : @controller.fillOutForms
      '#fill-out-forms-and-submit' : @controller.fillOutFormsAndSubmit
      '#peteshow-toggle': @show
      '#peteshow-hide': @hide

  _createEvents: (events) ->
    for key, value of events
      $(key).on 'click', (e) =>
        e.preventDefault()
        e.stopPropagation()
        events["##{e.target.id}"]() unless @dragging

    __handleDragMove = _.throttle(@_handleDragMove, 10)
    __handleDragDown = _.debounce(@_handleDragDown, 100)
    __handleDragUp = _.debounce(@_handleDragUp, 100)

    $('#peteshow-drag-handle').on 'mousedown', __handleDragDown
    $(document)
      .on 'mousemove', __handleDragMove
      .on 'mouseup', __handleDragUp

  _handleDragUp: =>
    @dragging = false
    document.onmousedown= -> return false
    store.set('position', @_position)

  _handleDragDown: =>
    @dragging = true
    document.onmousedown= -> return true

  _handleDragMove: (e) =>
    if @dragging
      position = {}
      position.x = e.pageX
      position.y = e.pageY
      @_positionWindow(position)

  _positionWindow: (position) ->
    $el = $("#peteshow")
    if position
      position.x = 0 if position.x < 0
      position.y = 0 if position.y < 0

      elBottom = $el.height() + $el.offset().top
      windowBottom = $(window).height()
      mouseBottomDiff = $el.offset().top - position.y + windowBottom - $el.height()

      cs.log position
      position.y = windowBottom - $el.height() if position.y >= mouseBottomDiff
      cs.log position
      @_position = position

    position ?= @_position
    $el.css(left: position.x, top: position.y)

  render: ->
    cs.log('PeteshowView::render')
    template = indexTemplate()
    $('body').append(template)
    @show()
    @_positionWindow()
    @_createEvents(@_events)

  show: =>
    cs.log('PeteshowView::show', @_active)
    $('#peteshow').toggleClass('active', @_active)
    $('#peteshow-tools').toggle(@_active)
    store.set('active', @_active)
    @_active = !@_active

  hide: ->
    cs.log('PeteshowView::hide')
    $('#peteshow').hide()

  destroy: ->
    cs.log('PeteshowView::destroy')
    $('#peteshow').remove()

module.exports = new PeteshowView()
