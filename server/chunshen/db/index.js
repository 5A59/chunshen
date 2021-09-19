const Q = require('q')
const MongoClient = require('mongodb').MongoClient
const DB_CONFIG = require('../../config').DB_CONFIG

const URL = DB_CONFIG.URL

const DB_NAME = 'chunshen'
const EXCERPT_TABLE_NAME = 'excerpt'
const TAG_TABLE_NAME = 'tag'

const COUNT_LIMIT = 5

// 按页获取书摘
exports.getExcerpts = (page, tags) => {
  let defer = Q.defer()
  let query = tags && tags.length > 0 ? { 'content.tag': { $in: tags } } : {}
  MongoClient.connect(URL, { useUnifiedTopology: true }, (err, db) => {
    let dbo = db.db(DB_NAME)
    // dbo.collection(EXCERPT_TABLE_NAME)
    //   .find(query, {
    //     skip: page * COUNT_LIMIT,
    //     limit: COUNT_LIMIT,
    //     sort: { 'content.time': -1 }
    //   })
    //   .toArray((err, result) => {
    //     if (err) {
    //       defer.resolve()
    //       db.close()
    //       return
    //     }
    //     defer.resolve(result)
    //     db.close()
    //   })

    dbo.collection(EXCERPT_TABLE_NAME)
      .aggregate([
        {
          $match: query
        },
        {
          $skip: page * COUNT_LIMIT
        },
        {
          $limit: COUNT_LIMIT
        },
        {
          $sort: { 'content.time': -1 }
        },
        { $addFields: { _tagId: { $toObjectId: 'tagId' } } },
        {
          $lookup: {
            from: TAG_TABLE_NAME,
            localField: '_tagId',
            foreignField: '_id',
            as: 'tag',
          }
        }
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
        const newRes = result.map((r) => {
          return {
            id: r._id.toString(),
            ...r
          }
        })
        defer.resolve(result)
        db.close()
      })
  })
  return defer.promise
}

exports.uploadExcerpts = () => {
}