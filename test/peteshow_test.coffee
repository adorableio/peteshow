process.env.NODE_ENV = 'test'
Browser = require('zombie')
Server  = require('./test_server')

describe 'PeteShow', ->
  browser = null
  before (done) ->
    @server = new Server({port: 3017})
    browser = new Browser({ site: 'http://localhost:3017' })
    done()

  beforeEach (done) ->
    browser.visit('/')
      .then ->
        browser.evaluate("Peteshow.init()")
        done()

  it 'is running the test server', (done) ->
    expect browser.success
    done()

  it 'is accessible in javascript', (done) ->
    browser.assert.evaluate('Peteshow')
    done()

  it 'exists in the DOM', (done) ->
    browser.assert.element('#peteshow')
    done()
