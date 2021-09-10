
var express = require('express');
var router = express.Router();
const { getExcerpts, getRamble, getTags } = require('../chunshen/api')

router.get('/excerpts', getExcerpts)
router.get('/ramble', getRamble)
router.get('/tags', getTags)

module.exports = router;
