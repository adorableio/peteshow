describe 'Hotkeys', ->

  beforeEach (done) ->
    browser.visit('/')
      .then ->
        initDewey = "Dewey.init()"
        browser.evaluate(initDewey)
        done()

  it 'should show dewey when backtick is pressed', (done) ->
    browser.assert.hasNoClass('#dewey', 'open')
    browser.key('down', 192)
    browser.assert.hasClass('#dewey', 'open')
    done()

  it 'should fill out forms when F is pressed', (done) ->
    browser.evaluate("Dewey.open(true)")
    browser.key('down', 70)
    browser.assert.inputFirst("input", /^.+$/)
    done()

