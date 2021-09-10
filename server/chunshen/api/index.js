
const utils = require('../utils')
const db = require('../db')

exports.getExcerpts = (req, res, next) => {
  const { page } = req.query
  db.getExcerpts(page)
    .then((excerpts) => {
      setTimeout(() => {
        res.send(utils.getSuccessRes({ data: excerpts }))
      }, 1000)
    })
    .catch((err) => {
      next(utils.getFailRes(err))
    })
}

exports.getRamble = (req, res, next) => {
  db.getRamble()
    .then((excerpts) => {
      setTimeout(() => {
        res.send(utils.getSuccessRes({ data: excerpts }))
      }, 5000)
    })
    .catch((err) => {
      next(utils.getFailRes(err))
    })
}

exports.getTags = (req, res, next) => {
  db.getTags()
    .then((tags) => {
      res.send(utils.getSuccessRes({ data: tags }))
    })
    .catch((err) => {
      next(utils.getFailRes(err))
    })
}