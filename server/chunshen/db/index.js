const Q = require('q')
const { MongoClient, ObjectId } = require('mongodb')
const DB_CONFIG = require('../../config').DB_CONFIG

const URL = DB_CONFIG.URL

const DB_NAME = 'chunshen'
const EXCERPT_TABLE_NAME = 'excerpt'
const TAG_TABLE_NAME = 'tag'
const COMMENT_TABLE_NAME = 'comment'
const BOOK_TABLE_NAME = 'book'

const COUNT_LIMIT = 5

function reformatTag(tag) {
  return {
    ...tag,
    id: tag._id.toString()
  }
}

function reformatExcerpt(list) {
  return list.map((r) => {
    return {
      ...r,
      tag: reformatTag(r.tag[0]),
    }
  })
}

function lookUpTag() {
  return [
    { $addFields: { _tagId: { $toObjectId: '$tagId' } } },
    {
      $lookup: {
        from: TAG_TABLE_NAME,
        localField: '_tagId',
        foreignField: '_id',
        as: 'tag',
      }
    }
  ]
}

function loopUpComment() {
  return [
    {
      $addFields: {
        comment: {
          $map: {
            input: '$comment',
            as: 'c',
            in: {
              $toObjectId: '$$c'
            }
          }
        }
      }
    },
    {
      $lookup: {
        from: COMMENT_TABLE_NAME,
        localField: 'comment',
        foreignField: '_id',
        as: 'comment',
      }
    }
  ]
}

// 按页获取书摘
exports.getExcerpts = (page, tags) => {
  let defer = Q.defer()
  let query = tags && tags.length > 0 ? { 'tagId': { $in: tags } } : {}
  MongoClient.connect(URL, { useUnifiedTopology: true }, (err, db) => {
    let dbo = db.db(DB_NAME)
    dbo.collection(EXCERPT_TABLE_NAME)
      .aggregate([
        {
          $match: query
        },
        {
          $sort: { 'content.time': -1 }
        },
        {
          $skip: page * COUNT_LIMIT
        },
        {
          $limit: COUNT_LIMIT
        },
        ...lookUpTag(),
        ...loopUpComment()
      ])
      .toArray((err, result) => {
        if (err) {
          defer.resolve()
          db.close()
          return
        }
        const newRes = reformatExcerpt(result)
        defer.resolve(newRes)
        db.close()
      })
  })
  return defer.promise
}

// 获取漫步消息，随机取 20 条数据
exports.getRamble = () => {
  let defer = Q.defer()
  MongoClient.connect(URL, { useUnifiedTopology: true }, (err, db) => {
    let dbo = db.db(DB_NAME)
    dbo.collection(EXCERPT_TABLE_NAME)
      .aggregate([
        { $sample: { size: COUNT_LIMIT } },
        ...lookUpTag(),
        ...loopUpComment()
      ])
      .toArray((err, result) => {
        if (err) {
          defer.resolve()
          db.close()
          return
        }
        const newRes = reformatExcerpt(result)
        defer.resolve(newRes)
        db.close()
      })
  })
  return defer.promise
}

// 获取书
exports.getTags = () => {
  let defer = Q.defer()
  MongoClient.connect(URL, { useUnifiedTopology: true }, (err, db) => {
    let dbo = db.db(DB_NAME)
    dbo.collection(TAG_TABLE_NAME)
      .find({})
      .sort({
        'time': -1
      })
      .toArray((err, result) => {
        if (err) {
          defer.resolve()
          db.close()
          return
        }
        const newRes = result.map((r) => {
          return reformatTag(r)
        })
        defer.resolve(newRes)
        db.close()
      })
  })
  return defer.promise
}

exports.addTag = (tag) => {
  let defer = Q.defer()
  MongoClient.connect(URL, { useUnifiedTopology: true }, (err, db) => {
    let dbo = db.db(DB_NAME)
    dbo.collection(TAG_TABLE_NAME).insertOne(tag, (err, res) => {
      if (err) {
        defer.reject(err)
        db.close()
        return
      }
      defer.resolve(tag)
      db.close()
    })
  })
  return defer.promise
}

exports.addBook = (book) => {
  let defer = Q.defer()
  MongoClient.connect(URL, { useUnifiedTopology: true }, (err, db) => {
    let dbo = db.db(DB_NAME)
    dbo.collection(BOOK_TABLE_NAME).updateOne(
      book,
      {
        $set: {}
      },
      {
        upsert: true
      },
      (err, res) => {
        if (err) {
          defer.reject(err)
          db.close()
          return
        }
        defer.resolve(book)
        db.close()
      })
  })
  return defer.promise
}

exports.uploadExcerpt = (excerpt) => {
  let defer = Q.defer()
  MongoClient.connect(URL, { useUnifiedTopology: true }, (err, db) => {
    let dbo = db.db(DB_NAME)
    dbo.collection(EXCERPT_TABLE_NAME).insertOne(excerpt, (err, res) => {
      if (err) {
        defer.reject(err)
        db.close()
        return
      }
      defer.resolve()
      db.close()
    })
  })
  return defer.promise
}

exports.updateExcerpt = (excerpt) => {
  let defer = Q.defer()
  MongoClient.connect(URL, { useUnifiedTopology: true }, (err, db) => {
    let dbo = db.db(DB_NAME)
    dbo.collection(EXCERPT_TABLE_NAME).updateOne(
      { _id: ObjectId(excerpt.id) },
      {
        $set: {
          tagId: excerpt.tagId,
          'content.content': excerpt.content
        }
      },
      {
        upsert: true
      },
      (err, res) => {
        if (err) {
          defer.reject(err)
          db.close()
          return
        }
        defer.resolve()
        db.close()
      })
  })
  return defer.promise
}

exports.deleteExcerpt = (id) => {
  let defer = Q.defer()
  MongoClient.connect(URL, { useUnifiedTopology: true }, (err, db) => {
    let dbo = db.db(DB_NAME)
    dbo.collection(EXCERPT_TABLE_NAME).deleteOne(
      { _id: ObjectId(id) },
      (err, res) => {
        if (err) {
          defer.reject(err)
          db.close()
          return
        }
        defer.resolve()
        db.close()
      })
  })
  return defer.promise
}

exports.insertCommentInExcerpt = (excerptId, commentId) => {
  let defer = Q.defer()
  MongoClient.connect(URL, { useUnifiedTopology: true }, (err, db) => {
    let dbo = db.db(DB_NAME)
    dbo.collection(EXCERPT_TABLE_NAME)
      .updateOne(
        { _id: ObjectId(excerptId) },
        { $push: { 'comment': commentId } },
        (err, res) => {
          if (err) {
            defer.reject(err)
            db.close()
            return
          }
          defer.resolve()
          db.close()
        })
  })
  return defer.promise
}

exports.removeCommentInExcerpt = (excerptId, commentId) => {
  let defer = Q.defer()
  MongoClient.connect(URL, { useUnifiedTopology: true }, (err, db) => {
    let dbo = db.db(DB_NAME)
    dbo.collection(EXCERPT_TABLE_NAME)
      .updateOne(
        { _id: ObjectId(excerptId) },
        { $pull: { 'comment': commentId } },
        (err, res) => {
          if (err) {
            defer.reject(err)
            db.close()
            return
          }
          defer.resolve()
          db.close()
        })
  })
  return defer.promise
}

exports.uploadComment = (comment) => {
  let defer = Q.defer()
  MongoClient.connect(URL, { useUnifiedTopology: true }, (err, db) => {
    let dbo = db.db(DB_NAME)
    dbo.collection(COMMENT_TABLE_NAME).insertOne(comment, (err, res) => {
      if (err) {
        defer.reject(err)
        db.close()
        return
      }
      defer.resolve(comment)
      db.close()
    })
  })
  return defer.promise
}

exports.deleteComment = (id) => {
  let defer = Q.defer()
  MongoClient.connect(URL, { useUnifiedTopology: true }, (err, db) => {
    let dbo = db.db(DB_NAME)
    dbo.collection(COMMENT_TABLE_NAME).deleteOne(
      { _id: ObjectId(id) },
      (err, res) => {
        if (err) {
          defer.reject(err)
          db.close()
          return
        }
        defer.resolve()
        db.close()
      })
  })
  return defer.promise
}

exports.deleteTag = (id) => {
  let defer = Q.defer()
  MongoClient.connect(URL, { useUnifiedTopology: true }, (err, db) => {
    let dbo = db.db(DB_NAME)
    dbo.collection(TAG_TABLE_NAME).deleteOne(
      { _id: ObjectId(id) },
      (err, res) => {
        if (err) {
          defer.reject(err)
          db.close()
          return
        }
        defer.resolve()
        db.close()
      })
  })
  return defer.promise
}

exports.deleteExcerptByTag = (tagId) => {
  let defer = Q.defer()
  MongoClient.connect(URL, { useUnifiedTopology: true }, (err, db) => {
    let dbo = db.db(DB_NAME)
    dbo.collection(EXCERPT_TABLE_NAME).deleteMany(
      { tagId: tagId },
      (err, res) => {
        if (err) {
          defer.reject(err)
          db.close()
          return
        }
        defer.resolve()
        db.close()
      })
  })
  return defer.promise
}