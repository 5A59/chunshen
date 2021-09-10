const Q = require('q')
const MongoClient = require('mongodb').MongoClient
const DB_CONFIG = require('../../config').DB_CONFIG

const URL = DB_CONFIG.URL

const DB_NAME = 'chunshen'
const EXCERPT_TABLE_NAME = 'excerpt'
const TAG_TABLE_NAME = 'tag'

const COUNT_LIMIT = 5

// 按页获取书摘
exports.getExcerpts = (page) => {
  let defer = Q.defer()
  MongoClient.connect(URL, { useUnifiedTopology: true }, (err, db) => {
    let dbo = db.db(DB_NAME)
    dbo.collection(EXCERPT_TABLE_NAME)
      .find({}, {
        skip: page * COUNT_LIMIT,
        limit: COUNT_LIMIT,
        sort: 'content.time'
      })
      .toArray((err, result) => {
        if (err) {
          defer.resolve()
          db.close()
          return
        }
        defer.resolve(result)
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
        { $sample: { size: COUNT_LIMIT } }
      ])
      .toArray((err, result) => {
        if (err) {
          defer.resolve()
          db.close()
          return
        }
        defer.resolve(result)
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
      .toArray((err, result) => {
        if (err) {
          defer.resolve()
          db.close()
          return
        }
        defer.resolve(result)
        db.close()
      })
  })
  return defer.promise
}