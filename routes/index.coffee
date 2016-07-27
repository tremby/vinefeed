express = require 'express'
router = express.Router()

router.get /^\/users\/(\d+)\/(atom|rss)$/, require './users'
router.get /\/favicon\.ico$/, require './favicon'

module.exports = router
