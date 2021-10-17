const utils = require('../utils')
const db = require('../db')
const Q = require('q')

const register = (username, password) => {
  const user = { username, password }
  return db.addUser(user)
}

const checkPassword = (pwd, oldPwd) => {
  return pwd?.toLowerCase() == oldPwd?.toLowerCase()
}

exports.login = (req, res, next) => {
  const { username, password } = req.body
  db.getUser(username)
    .then((user) => {
      if (user) {
        return user
      }
      return register(username, password)
    })
    .then((user) => {
      if (user && checkPassword(user.password, password)) {
        req.session.username = username
        res.cookie('username', username)
        res.send(utils.getLoginRes())
      } else {
        next(utils.getFailRes('password error'))
      }
    })
    .catch((err) => {
      next(utils.getFailRes(err))
    })
}

exports.changePassword = (req, res, next) => {
  const { username, newPassword, oldPassword } = req.body
  db.getUser(username)
    .then((user) => {
      if (user && checkPassword(user.password, oldPassword)) {
        return register(username, newPassword)
      }
      return undefined
    })
    .then((user) => {
      if (user) {
        res.send(utils.getSuccessRes('修改密码成功'))
      } else {
        next(utils.getFailRes('修改密码失败'))
      }
    })
    .catch((err) => {
      next(utils.getFailRes(err))
    })
}