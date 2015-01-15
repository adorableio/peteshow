describe 'Helpers', ->

  beforeEach (done) ->
    browser.visit('/')
      .then ->
        initPeteshow = "Peteshow.init();"
        browser.evaluate(initPeteshow)
        done()

  it 'exposes the Peteshow.random object', (done) ->
    browser.assert.evaluate('Peteshow.random')
    done()

  it 'generates random values', (done) ->
    browser.assert.evaluate('Peteshow.random.date()'        , REGEX.DATE)
    browser.assert.evaluate('Peteshow.random.letters()'     , REGEX.TEXT)
    browser.assert.evaluate('Peteshow.random.number()'      , REGEX.NUMBER)
    browser.assert.evaluate('Peteshow.random.phoneNumber()' , REGEX.PHONE_NUMBER)
    browser.assert.evaluate('Peteshow.random.name()'        , REGEX.TEXT)
    browser.assert.evaluate('Peteshow.random.firstName()'   , REGEX.TEXT)
    browser.assert.evaluate('Peteshow.random.lastName()'    , REGEX.TEXT)
    browser.assert.evaluate('Peteshow.random.companyName()' , REGEX.TEXT)
    browser.assert.evaluate('Peteshow.random.email()'       , REGEX.EMAIL)
    browser.assert.evaluate('Peteshow.random.street()'      , REGEX.TEXT)
    browser.assert.evaluate('Peteshow.random.secondary()'   , REGEX.TEXT)
    browser.assert.evaluate('Peteshow.random.city()'        , REGEX.TEXT)
    browser.assert.evaluate('Peteshow.random.county()'      , REGEX.TEXT)
    browser.assert.evaluate('Peteshow.random.state()'       , REGEX.TEXT)
    browser.assert.evaluate('Peteshow.random.stateAbbr()'   , REGEX.STATE_ABBR)
    browser.assert.evaluate('Peteshow.random.zipCode()'     , REGEX.ZIP_CODE)
    browser.assert.evaluate('Peteshow.random.catchPhrase()' , REGEX.TEXT)
    browser.assert.evaluate('Peteshow.random.sentences()'   , REGEX.TEXT)
    done()
