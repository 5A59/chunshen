
const utils = require('../utils')
const db = require('../db')

exports.getExcerpts = (req, res, next) => {
  const { page, tags = '[]' } = req.query
  db.getExcerpts(page, JSON.parse(tags))
    .then((excerpts) => {
      res.send(utils.getSuccessRes({ data: excerpts }))
    })
    .catch((err) => {
      next(utils.getFailRes(err))
    })
}

exports.getRamble = (req, res, next) => {
  db.getRamble()
    .then((excerpts) => {
      res.send(utils.getSuccessRes({ data: excerpts }))
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

exports.uploadExcerpt = (req, res, next) => {
  const { content, comment, tagId } = req.body
  if (comment) {
    const commentObj = {
      content: comment,
      time: Date.now()
    }
    db.uploadComment(commentObj)
      .then((id) => {
        const excerpt = {
          tagId,
          content: {
            time: Date.now(),
            content
          },
          comment: [id]
        }
        return db.uploadExcerpt(excerpt)
      })
      .then(() => {
        res.send(utils.getSuccessRes({}))
      })
      .catch((err) => {
        next(utils.getFailRes(err))
      })
  } else {
    const excerpt = {
      tagId,
      content: {
        time: Date.now(),
        content
      },
      comment: []
    }
    db.uploadExcerpt(excerpt)
      .then(() => {
        res.send(utils.getSuccessRes({}))
      })
      .catch((err) => {
        next(utils.getFailRes(err))
      })
  }
}

exports.uploadComment = (req, res, next) => {
  const { excerptId, content } = req.body
  const comment = {
    excerptId,
    content,
    time: Date.now()
  }
  db.uploadComment(comment)
    .then((id) => {
      return db.insertCommentInExcerpt(excerptId, id)
    })
    .then(() => {
      res.send(utils.getSuccessRes({}))
    })
    .catch((err) => {
      next(utils.getFailRes(err))
    })
}