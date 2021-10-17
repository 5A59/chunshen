
var express = require('express');
var router = express.Router();
const {
	getExcerpts,
	getRamble,
	getTags,
	addTag,
	deleteTag,
	uploadExcerpt,
	deleteExcerpt,
	uploadComment,
	deleteComment,
} = require('../chunshen/api')

router.get('/excerpts', getExcerpts)
router.get('/ramble', getRamble)
router.get('/tags', getTags)
router.post('/excerpt', uploadExcerpt)
router.post('/comment', uploadComment)
router.post('/deleteExcerpt', deleteExcerpt)
router.post('/tag', addTag)
router.post('/deleteComment', deleteComment)
router.post('/deleteTag', deleteTag)

module.exports = router;
