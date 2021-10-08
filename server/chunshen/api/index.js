const utils = require('../utils')
const db = require('../db')
const Q = require('q')

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

const updateExcerpt = (req, res, next) => {
  const { content, tagId, id } = req.body
  const excerpt = {
    id,
    tagId,
    content
  }
  db.updateExcerpt(excerpt)
    .then(() => {
      res.send(utils.getSuccessRes({}))
    })
    .catch((err) => {
      next(utils.getFailRes(err))
    })
}

exports.uploadExcerpt = (req, res, next) => {
  const { content, comment, tagId, id, image } = req.body
  if (id) {
    updateExcerpt(req, res, next);
    return;
  }
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
          image,
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
      image,
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
    .then((comment) => {
      return db.insertCommentInExcerpt(excerptId, comment._id.toString())
    })
    .then(() => {
      res.send(utils.getSuccessRes(comment))
    })
    .catch((err) => {
      next(utils.getFailRes(err))
    })
}

exports.deleteExcerpt = (req, res, next) => {
  const { id } = req.body
  if (!id) {
    next(utils.getFailRes(err))
    return
  }
  db.deleteExcerpt(id)
    .then(() => {
      res.send(utils.getSuccessRes({}))
    })
    .catch((err) => {
      next(utils.getFailRes(err))
    })
}

const addBook = (book) => {
  db.addBook(book).then().catch()
}

exports.addTag = (req, res, next) => {
  const { head, content, publish, self } = req.body
  if (!content) {
    next(utils.getFailRes('content is null'))
    return;
  }
  const tag = {
    head,
    content,
    self,
    time: Date.now(),
  }
  const book = {
    head, content, publish
  }
  db.addTag(tag)
    .then(() => {
      res.send(utils.getSuccessRes({}))
      if (!self) {
        addBook(book)
      }
    })
    .catch((err) => {
      next(utils.getFailRes(err))
      if (!self) {
        addBook(book)
      }
    })
}

exports.deleteComment = (req, res, next) => {
  const { excerptId, id } = req.body
  if (!excerptId || !id) {
    next(utils.getFailRes('excerptId or id is null'))
    return;
  }
  Q.all([db.deleteComment(id), db.removeCommentInExcerpt(excerptId, id)])
    .then(() => {
      res.send(utils.getSuccessRes({}))
    })
    .catch((err) => {
      next(utils.getFailRes(err))
    })
}

exports.deleteTag = (req, res, next) => {
  const { id } = req.body
  if (!id) {
    next(utils.getFailRes('id is null'))
    return;
  }
  Q.all([db.deleteTag(id), db.deleteExcerptByTag(id)])
    .then(() => {
      res.send(utils.getSuccessRes({}))
    })
    .catch((err) => {
      next(utils.getFailRes(err))
    })
}