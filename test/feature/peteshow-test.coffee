describe 'PeteShow', ->

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
    browser.assert.evaluate('Peteshow.fillOutForms()')


    fields =
      'input[type=password]'                      : 'password'
      'input[type=text]'                          : REGEX.TEXT
      'input[type=email], input[name*=email]'     : REGEX.EMAIL
      'input[name*=number], input[type=number]'   : REGEX.NUMBER
      'input[type=date]'                          : REGEX.DATE
      'input[name*=first_name]'                   : REGEX.TEXT
      'input[name*=last_name]'                    : REGEX.TEXT
      'input[name*=company]'                      : REGEX.TEXT
      'input[name*=street], input[name*=line1]'   : REGEX.TEXT
      'input[name*=line2], input[name*=suite]'    : REGEX.TEXT
      'input[name*=city]'                         : REGEX.TEXT
      'input[name*=state]'                        : REGEX.TEXT
      'input[name*=job_title]'                    : REGEX.TEXT
      'input[name*=intent]'                       : REGEX.TEXT
      'input[name*=income], input[name*=amount]'  : REGEX.NUMBER
      'input[name*=branch], input[name*=routing]' : '400001'
      'input[name*=card_type_cd]'                 : '001'
      'input[name*=card_number]'                  : '4111111111111111'
      'input[name*=cvv]'                          : '123'

    for element, match of fields
      browser.assert.inputFirst(element, match)
    done()

  it 'should ignore fields', (done) ->
    browser.assert.evaluate('Peteshow.fillOutForms()')
    browser.assert.inputFirst('input[name=phone]', "")
    done()

  it 'should have valid values from plugin after filling out forms', (done) ->
    browser.assert.evaluate('Peteshow.fillOutForms()')
    browser.assert.inputFirst('input[name*=zip]', 60611)
    browser.assert.inputFirst('input[name*=custom_name]', 'Custom')
    done()

  it 'should not change value of checkbox but attribute checked', (done) ->
    browser.assert.evaluate('Peteshow.fillOutForms()')
    browser.assert.evaluate("$('input[name=boolean_checkbox]').val()", 1)
    browser.assert.evaluate("$('input[name=boolean_checkbox]').prop('checked')", true)
    done()
