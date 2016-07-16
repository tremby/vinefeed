request = require 'request'
fs = require 'fs'
os = require 'os'
path = require 'path'
CACHEFILE = 'favicon.ico'

module.exports = (req, res, next) ->
	res.sendFile CACHEFILE, root: os.tmpdir(), (error) ->
		return unless error?
		request "https://vine.co/", (error, response, body) ->
			return next error if error?
			unless response.statusCode is 200
				error = new Error "Unexpected response code #{response.statusCode} while getting vine.co homepage"
				error.status = 500
				return next error
			request (/https:\/\/[^"]*?favicon\.ico/.exec body)[0]
				.on 'error', (error) ->
					error = new Error "Could not retrieve favicon"
					error.status = 500
					return next error
				.on 'end', () ->
					res.sendFile CACHEFILE, root: os.tmpdir()
				.pipe fs.createWriteStream path.join os.tmpdir(), CACHEFILE
