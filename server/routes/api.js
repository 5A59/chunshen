
var express = require('express');
var router = express.Router();
const { getExcerpts, getRamble, getTags, uploadExcerpt, uploadComment } = require('../chunshen/api')

router.get('/excerpts', getExcerpts)
router.get('/ramble', getRamble)
router.get('/tags', getTags)
router.post('/excerpt', uploadExcerpt)
router.post('/comment', uploadComment)

module.exports = router;
