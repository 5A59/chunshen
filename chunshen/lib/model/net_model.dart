import 'package:chunshen/model/spider/index.dart';
import 'package:chunshen/model/tag.dart';
import 'package:chunshen/model/user.dart';
import 'package:chunshen/net/index.dart';

import 'excerpt.dart';
import 'dart:convert';

class BaseModel {
  static Map<String, dynamic> _parseJson(String data) {
    return jsonDecode(data);
  }
}

class ExcerptNetModel extends BaseModel {
  static Future<ExcerptListBean> getExcerptListBean(
      int page, Set<String>? tags) async {
    CSResponse resp = await httpGet('/api/excerpts', query: {
      "page": page,
      "tags": jsonEncode(tags?.map((e) => e).toList() ?? [])
    });
    // Map<String, dynamic> data = _parseJson(TESTDATA);
    Map<String, dynamic> data = BaseModel._parseJson(resp.data);
    return ExcerptListBean.fromJson(data);
  }

  static Future<CSResponse> uploadNewExcerpt(ExcerptUploadBean bean) async {
    CSResponse resp = await httpPost('/api/excerpt', body: bean);
    return resp;
  }
}

class TagNetModel extends BaseModel {
  static Future<TagListBean> getTagListBean() async {
    CSResponse resp = await httpGet('/api/tags');
    Map<String, dynamic> data = BaseModel._parseJson(resp.data);
    return TagListBean.fromJson(data);
  }

  static search(String tag) async {
    return DoubanSpider().search(tag);
  }

  static addTag(TagBean tag) async {
    CSResponse resp = await httpPost('/api/tag', body: tag);
    return resp;
  }
}

class RambleNetModel extends BaseModel {
  static Future<List<ExcerptBean>> getRambleData() async {
    CSResponse resp = await httpGet('/api/ramble');
    Map<String, dynamic> data = BaseModel._parseJson(resp.data);
    return ExcerptListBean.fromJson(data).content;
  }
}

class CommentNetModel {
  static Future<ExcerptCommentBean?> uploadNewComment(
      String? excerptId, String? content) async {
    CSResponse resp = await httpPost('/api/comment',
        body: CommentUploadBean(excerptId, content));
    if (CSResponse.success(resp)) {
      Map<String, dynamic> data = BaseModel._parseJson(resp.data);
      return ExcerptCommentBean.fromJson(data);
    }
    return null;
  }
}

class DeleteNetModel {
  static Future<CSResponse> deleteExcerpt(String? id) async {
    if (id == null) {
      return CSResponse.error();
    }
    CSResponse response =
        await httpPost('/api/deleteExcerpt', body: DeleteBean(id));
    return response;
  }

  static Future<CSResponse> deleteTag(String? id) async {
    if (id == null) {
      return CSResponse.error();
    }
    CSResponse response =
        await httpPost('/api/deleteTag', body: DeleteBean(id));
    return response;
  }

  static Future<CSResponse> deleteComment(String? excerptId, String? id) async {
    if (id == null || excerptId == null) {
      return CSResponse.error();
    }
    CSResponse response = await httpPost('/api/deleteComment',
        body: CommentDeleteBean(excerptId, id));
    return response;
  }
}

class UserNetModel {
  static Future<CSResponse> login(String? username, String? password) async {
    if (username == null || password == null) {
      return CSResponse.error();
    }
    CSResponse response =
        await httpPost('/user/login', body: UserBean(username, password));
    return response;
  }
}
