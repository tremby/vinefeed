express = require 'express'
router = express.Router()

router.get /^\/users\/(\d+)\/(atom|rss)$/, require './users'

module.exports = router
