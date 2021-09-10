import 'package:chunshen/model/tag.dart';
import 'package:chunshen/net/index.dart';

import 'excerpt.dart';
import 'test.dart';
import 'dart:convert';

class ExcerptModel {
  ExcerptModel._();

  factory ExcerptModel.init() {
    return ExcerptModel._();
  }

  static Map<String, dynamic> _parseJson(String data) {
    return jsonDecode(data);
  }

  static Future<ExcerptListBean> getExcerptListBean(int page) async {
    CSResponse resp = await httpGet('/excerpts', query: {"page": page});
    // Map<String, dynamic> data = _parseJson(TESTDATA);
    Map<String, dynamic> data = _parseJson(resp.data);
    return ExcerptListBean.fromJson(data);
  }
}

class TagModel {
  TagModel._();

  factory TagModel.init() {
    return TagModel._();
  }

  static Map<String, dynamic> _parseJson(String data) {
    return jsonDecode(data);
  }

  static TagListBean getTagListBean() {
    Map<String, dynamic> data = _parseJson(TEST_TAG_DATA);
    return TagListBean.fromJson(data);
  }
}

class RambleModel {
  RambleModel._();

  factory RambleModel.init() {
    return RambleModel._();
  }

  static Map<String, dynamic> _parseJson(String data) {
    return jsonDecode(data);
  }

  static Future<List<ExcerptBean>> getRambleData() async {
    CSResponse resp = await httpGet('/ramble');
    Map<String, dynamic> data = _parseJson(resp.data);
    return ExcerptListBean.fromJson(data).content;
  }
}
