describe 'Storage', ->

  beforeEach (done) ->
    browser.visit('/')
      .then ->
        initDewey = "Dewey.init({
          resets: ['form[name=random]']
        });"
        browser.evaluate(initDewey)
        done()

  checkStorage = (value) ->
    it "restores the open state from last session", (done) ->
      browser.assert.evaluate("Dewey.store.get('open')", value)
      done()

  it "changes the open state to true", (done) ->
    browser.evaluate("Dewey.open(true)")
    browser.assert.hasClass('#dewey', 'open')
    done()
  checkStorage(true)

  it "changes the open state to true", (done) ->
    browser.evaluate("Dewey.open(false)")
    browser.assert.hasNoClass('#dewey', 'open')
    done()

  context "Last Session", ->
    it "switches you to new session when visiting the first form page", (done) ->
      browser.assert.evaluate("$('#dewey .dewey-sessions [data-session=new]').prop('checked')", true)
      done()

    it "creates last session after submitting a form", (done) ->
      browser.pressButton "submit", (err) ->
        browser.assert.evaluate("$('#dewey .dewey-sessions [data-session=last]').prop('checked')", true)
        # browser.assert.success()
        done()
      # .then ->
      #   done()

    it "restores last session", (done) ->
      expect(false).to.be(true)
      done()

  checkStorage(false)
