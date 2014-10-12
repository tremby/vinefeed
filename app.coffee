express = require 'express'
path = require 'path'
logger = require 'morgan'

routes = require './routes/index'

app = express()

app.enable 'trust proxy'
app.use logger if app.get('env') is 'development' then 'dev' else 'combined'

app.use '/', routes

# Catch 404 and forward to error handler
app.use (req, res, next) ->
	err = new Error 'Not Found'
	err.status = 404
	next err

# Development error handler (will print stack trace)
if app.get('env') is 'development'
	app.use (err, req, res, next) ->
		res.status err.status or 500
		console.log err.status, err.message, err
		res.send
			status: 'error'
			message: err.message
			error: err

# Production error handler (no stack trace)
app.use (err, req, res, next) ->
	res.status err.status or 500
	res.send
		status: 'error'
		message: err.message
		error: {}

module.exports = app
