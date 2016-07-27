request = require 'request'

url = null

module.exports = (req, res, next) ->
	if url?
		res.redirect 301, url
		return
	request "https://vine.co/", (error, response, body) ->
		return next error if error?
		unless response.statusCode is 200
			error = new Error "Unexpected response code #{response.statusCode} while getting vine.co homepage"
			error.status = 500
			return next error
		url = /\bhttps:\/\/[^"]*?favicon\.ico\b/.exec(body)[0]
		res.redirect 301, url
