_             = require('lodash')
indexTemplate = require('../templates/index.hbs')
store         = require('./storage')
cs            = require('calmsoul')

class DeweyView
  controller: Dewey.controller
  _events: {}

  $dewey: '#dewey'
  $dragHandle: '#dewey-drag-handle'
  $tools: '#dewey-tools'
  $sessions: '.dewey-sessions'

  constructor: ->
    cs.log("DeweyView::init")
    @_position = store.get('position') || {x:0, y:0}

    @_open = store.get('open')
    @_open = if typeof @_open != "boolean" then false else @_open

    @_events =
      '#fill-out-forms' : @controller.fillOutForms
      '#fill-out-forms-and-submit' : @controller.fillOutFormsAndSubmit
      '#dewey-toggle': @open
      '#dewey-hide': @hide

  _bindElements: ->
    @$dewey      = $(@$dewey)
    @$tools      = $(@$tools)
    @$dragHandle = $(@$dragHandle)
    @$sessions   = $(@$sessions)

  _createEvents: (events) ->
    for key, value of events
      $(key).on 'click', (e) =>
        e.preventDefault()
        e.stopPropagation()
        events["##{e.target.id}"]() unless @dragging

    __handleDragMove = _.throttle(@_handleDragMove, 10)
    __handleDragDown = _.debounce(@_handleDragDown, 100)
    __handleDragUp = _.debounce(@_handleDragUp, 100)

    @$dragHandle.on 'mousedown', __handleDragDown
    $(document)
      .on 'mousemove', __handleDragMove
      .on 'mouseup', __handleDragUp

    $(document).keydown @_handleKeypress

    $('form[name=registration], form[class=simple_form]').on 'submit', (e) ->
      return

    @$sessions.find('input:radio').on 'change', (e) =>
      id = $(e.currentTarget).data('session')
      @controller.setSession(id)

  _handleKeypress: (e) =>
    # key  = if (typeof e.which == 'number') then e.which else e.keyCode
    code = String.fromCharCode(e.keyCode)

    # # modifier keys
    # code = 'ctrl_'+code if (e.ctrlKey)
    # if (e.altKey || (e.originalEvent && e.originalEvent.metaKey))
    #   code = 'alt_'+code
    # if (e.shiftKey)
    #   code = 'shift_'+code
    # return if ($.inArray(e.keyCode, [9,16,17,18, 91, 93, 224]) != -1)
    # return if (e.metaKey)

    cs.log(e.keyCode)
    @open() if (e.keyCode == 192)

    action  = $("[data-command='#{code}']")
    visible = @$dewey.is('.open')

    action.click() if (action.length > 0 && visible)

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
    $el = @$dewey
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
    cs.log('DeweyView::render')

    template = indexTemplate()
    $('body').append(template)

    @_bindElements()
    @_positionWindow()
    @_createEvents(@_events)
    @open(@_open)

  setSession: (id) ->
    @$sessions.find("[data-session=#{id}]").prop('checked', true).change()

  open: (open) =>
    if open == undefined
      open = !@_open

    cs.log('DeweyView::open', open)

    @$dewey.toggleClass('open', open)
    @$tools.toggle(open)

    store.set('open', open)
    @_open = open

  hide: =>
    cs.log('DeweyView::hide')
    @$dewey.show(false)

  destroy: ->
    cs.log('DeweyView::destroy')
    @$dewey.remove()

module.exports = new DeweyView()
