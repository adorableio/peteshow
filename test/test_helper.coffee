{ isRegExp } = require("util")
chai         = require('chai')
assert       = require("assert")

process.env.NODE_ENV = 'test'

global.Server  = require('./test_server')
global.Browser = require('zombie')
global.expect  = chai.expect

assertMatch = (actual, expected, message)->
  if isRegExp(expected)
    assert expected.test(actual), message || "Expected '#{actual}' to match #{expected}"
  else if typeof(expected) == "function"
    assert expected(actual), message
  else
    assert.deepEqual actual, expected, message

# Zombie.js' assert.input() tests against querySelectorAll...
# causing failures against the desired behavior
Browser.Assert.prototype.inputFirst = (selector, expected, message) ->
  if arguments.length == 1
    expected = null
  element = @browser.query(selector)
  assert element, "Expected selector '#{selector}' to return one or more elements"

  value = element.value.replace(/(\r\n|\n|\r)/gm,"")
  assertMatch value, expected, message
