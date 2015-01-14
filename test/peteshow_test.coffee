describe 'PeteShow', ->
  browser = null
  before (done) ->
    @server = new Server({port: 3017})
    browser = new Browser({ site: 'http://localhost:3017' })
    done()

  beforeEach (done) ->
    browser.visit('/')
      .then ->
        initPeteshow = "Peteshow.init({
          rules: {
            'input[name*=zip]'              : '60611',
            'input[name*=middle_name]'      : faker.name.firstName(),
            'input[name*=custom_name]'      : function() { return 'Custom'; },
            'input[name*=boolean_checkbox]' : true
          },
          ignore : ['input[name=phone]', '#qunit-modulefilter']
        });"
        browser.evaluate(initPeteshow)
        done()

  it 'is running the test server', (done) ->
    expect browser.success
    done()

  it 'is accessible in javascript', (done) ->
    browser.assert.global('Peteshow')
    done()

  it 'exists in the DOM', (done) ->
    browser.assert.element('#peteshow')
    done()

  it 'should have valid values', (done) ->
    NUMBER_REGEX       = /^[0-9]*$/
    TEXT_REGEX         = /^[a-zA-Z0-9.',\/_ -]+$/
    EMAIL_REGEX        = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,6}$/i
    DATE_REGEX         = /^(19|20)\d\d([- /.])(0[1-9]|1[012])\2(0[1-9]|[12][0-9]|3[01])$/
    PHONE_NUMBER_REGEX = /\(\d{3}\)\d{3}-\d{4}/

    fields =
      'input[type=password]'                        : 'password'
      'input[type=text]'                            : TEXT_REGEX
      'input[type=email], input[name*=email]'       : EMAIL_REGEX
      'input[name*=number], input[type=number]'     : NUMBER_REGEX
      'input[type=date]'                            : DATE_REGEX
      'input[name*=first_name]'                     : TEXT_REGEX
      'input[name*=last_name]'                      : TEXT_REGEX
      'input[name*=company]'                        : TEXT_REGEX
      'input[name*=street], input[name*=line1]'     : TEXT_REGEX
      'input[name*=line2], input[name*=suite]'      : TEXT_REGEX
      'input[name*=city]'                           : TEXT_REGEX
      'input[name*=state]'                          : TEXT_REGEX
      'input[name*=job_title]'                      : TEXT_REGEX
      'input[name*=intent]'                         : TEXT_REGEX
      'input[name*=income], input[name*=amount]'    : NUMBER_REGEX
      'input[name*=branch], input[name*=routing]'   : '400001'
      'input[name*=card_type_cd]'                   : '001'
      'input[name*=card_number]'                    : '4111111111111111'
      'input[name*=cvv]'                            : '123'

    browser.assert.evaluate('Peteshow.fillOutForms()')
    browser.assert.inputFirst(k, v) for k, v of fields
    done()
