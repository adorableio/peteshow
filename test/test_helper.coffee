chai = require('chai')

process.env.NODE_ENV = 'test'

global.Server  = require('./test_server')
global.Browser = require('zombie')
global.expect  = chai.expect
