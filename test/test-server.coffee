express = require('express')

app = express()
app.use(express.static(__dirname + '/../.generated/'))

class Server
  defaults:
    host: 'http://localhost'
    port: 3002

  options: {}

  constructor: (options = {}) ->
    app.set('view engine', 'ejs')
    app.set('views', __dirname)
    app.get '/', (req, res) ->
      res.render('index', {env: process.env.NODE_ENV})

    @options.port = options.port || @defaults.port
    @options.host = options.host || @defaults.host
    app.listen(@options.port)

    if (!isTest)
      console.log("[TEST_SERVER] Server running at: #{@options.host}/#{@options.port}")

isTest = (process.env.NODE_ENV == 'test')
new Server() if (!isTest)
module.exports = Server
