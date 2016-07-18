request = require 'request'
Feed = require 'feed'

module.exports = (req, res, next) ->
	user = req.params[0]
	format = req.params[1]

	request "https://vine.co/api/timelines/users/#{user}", (error, response, body) ->
		return next error if error?
		unless response.statusCode is 200
			error = new Error "Unexpected response code #{response.statusCode} from vine.co"
			error.status = 500
			return next error
		body = JSON.parse body
		if not body.success or body.error
			error = new Error "Error from vine.co. Code: '#{body.code}', message '#{body.error}'"
			error.status = 500
			return next error
		records = body.data.records
		author = if records.length then records[0].username else "user #{user}"
		link = "https://vine.co/u/#{user}"

		feed = new Feed
			title: "Vines by #{author}"
			description: "" # Required in RSS
			link: link
			image: if records.length then records[0].avatarUrl else undefined

		for record in records
			id = record.permalinkUrl.replace /.*\//, ''
			feed.addItem
				title: record.description
				link: record.permalinkUrl
				description: """
					<iframe
							class="vine-embed"
							src="https://vine.co/v/#{id}/embed/postcard?related=0"
							width="600"
							height="600"
							frameborder="0"></iframe>
					<div>
						<small>
							<a href="#{record.videoUrl}">Direct link to video</a>
						</small>
					</div>
				"""
				date: new Date record.created
				image: record.thumbnailUrl
				author: [
					name: author
					link: link
				]

		payload = feed.render if format is 'atom' then 'atom-1.0' else 'rss-2.0'
		res.set 'Content-Type': if format is 'atom' then 'application/atom+xml' else 'application/rss+xml'
		res.send payload
