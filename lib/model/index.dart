import 'package:chunshen/model/tag.dart';

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

  static ExcerptListBean getExcerptListBean(int page) {
    Map<String, dynamic> data = _parseJson(TESTDATA);
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
