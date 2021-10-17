var express = require('express');
var router = express.Router();

const { login, changePassword } = require('../chunshen/user')

router.post('/login', login)
router.post('/changePwd', changePassword)

module.exports = router;
