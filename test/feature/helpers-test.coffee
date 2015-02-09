describe 'Helpers', ->

  beforeEach (done) ->
    browser.visit('/')
      .then ->
        initDewey = "Dewey.init();"
        browser.evaluate(initDewey)
        done()

  it 'exposes the Dewey.random object', (done) ->
    browser.assert.evaluate('Dewey.random')
    done()

  it 'generates random values', (done) ->
    check = (fn, matcher, message) -> browser.assert.evaluate("Dewey.random.#{fn}()", matcher, message)

    check('date'        , REGEX.DATE)
    check('letters'     , REGEX.TEXT)
    check('number'      , REGEX.NUMBER)
    check('phoneNumber' , REGEX.PHONE)
    check('name'        , REGEX.TEXT)
    check('firstName'   , REGEX.TEXT)
    check('lastName'    , REGEX.TEXT)
    check('companyName' , REGEX.TEXT)
    check('email'       , REGEX.EMAIL)
    check('street'      , REGEX.TEXT)
    check('secondary'   , REGEX.TEXT)
    check('city'        , REGEX.TEXT)
    check('county'      , REGEX.TEXT)
    check('state'       , REGEX.TEXT)
    check('stateAbbr'   , REGEX.STATE_ABBR)
    check('zipCode'     , REGEX.ZIP_CODE)
    check('catchPhrase' , REGEX.TEXT)
    check('sentences'   , REGEX.TEXT)
    done()
