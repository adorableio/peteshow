express = require('express')

app = express()
app.use(express.static(__dirname + '/dummy'))

class Server
  defaults:
    host: 'http://localhost'
    port: 3002

  options: {}

  constructor: (options = {}) ->
    @options.port = options.port || @defaults.port
    @options.host = options.host || @defaults.host
    app.listen(@options.port)
    console.log("[TEST_SERVER] Server running at: #{@options.host}/#{@options.port}")

module.exports = new Server()
