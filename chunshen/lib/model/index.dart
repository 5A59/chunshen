import 'package:chunshen/model/tag.dart';
import 'package:chunshen/net/index.dart';

import 'excerpt.dart';
import 'dart:convert';

class BaseModel {
  static Map<String, dynamic> _parseJson(String data) {
    return jsonDecode(data);
  }
}

class ExcerptModel extends BaseModel {
  ExcerptModel._();

  factory ExcerptModel.init() {
    return ExcerptModel._();
  }

  static Future<ExcerptListBean> getExcerptListBean(
      int page, Set<String>? tags) async {
    CSResponse resp = await httpGet('/excerpts', query: {
      "page": page,
      "tags": jsonEncode(tags?.map((e) => e).toList() ?? [])
    });
    // Map<String, dynamic> data = _parseJson(TESTDATA);
    Map<String, dynamic> data = BaseModel._parseJson(resp.data);
    return ExcerptListBean.fromJson(data);
  }

  static Future<CSResponse> uploadNewExcerpt(ExcerptUploadBean bean) async {
    CSResponse resp = await httpPost('/excerpt', body: bean);
    return resp;
  }
}

class TagModel extends BaseModel {
  TagModel._();

  factory TagModel.init() {
    return TagModel._();
  }

  static Future<TagListBean> getTagListBean() async {
    CSResponse resp = await httpGet('/tags');
    Map<String, dynamic> data = BaseModel._parseJson(resp.data);
    return TagListBean.fromJson(data);
  }
}

class RambleModel extends BaseModel {
  RambleModel._();

  factory RambleModel.init() {
    return RambleModel._();
  }

  static Future<List<ExcerptBean>> getRambleData() async {
    CSResponse resp = await httpGet('/ramble');
    Map<String, dynamic> data = BaseModel._parseJson(resp.data);
    return ExcerptListBean.fromJson(data).content;
  }
}

class CommentModel {
  CommentModel._();

  static Future<CSResponse> uploadNewComment(
      String? excerptId, String? content) async {
    CSResponse resp =
        await httpPost('/comment', body: CommentUploadBean(excerptId, content));
    return resp;
  }
}
