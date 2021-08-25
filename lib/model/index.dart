import 'excerpt.dart';
import 'test.dart';
import 'dart:convert';

class ExcerptModel {
  ExcerptModel._() {}

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
