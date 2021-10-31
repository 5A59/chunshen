import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../config.dart';

const DEBUG = kDebugMode;
const URL = '';

var _options = BaseOptions(baseUrl: DEBUG ? DEBUG_URL : URL);

Dio _dio = Dio(_options);

Future<bool> initNet() {
  return Future<bool>(() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    var cj = PersistCookieJar(
        ignoreExpires: true,
        storage: FileStorage(appDocDir.path + "/.cookies/"));
    _dio.interceptors.add(CookieManager(cj));
    return true;
  });
}

class CSResponse {
  int status = 0;
  String msg = '';
  String data = '';

  CSResponse._(this.status, this.msg, this.data);

  static bool success(CSResponse? resp) {
    return resp != null && resp.status == 0;
  }

  static bool fail(CSResponse? resp) {
    return resp == null || resp.status != 0;
  }

  static CSResponse error({int status = 1, String error = 'error'}) {
    return CSResponse._(status, error, '');
  }

  static CSResponse normal({int status = 0, String error = 'success'}) {
    return CSResponse._(status, error, '');
  }
}

Future<Response> rawGet(String path, {Map<String, dynamic>? query}) async {
  Response response = await _dio.get(path, queryParameters: query);
  return response;
}

Future<CSResponse> httpGet(String path, {Map<String, dynamic>? query}) async {
  Response response = await _dio.get(path, queryParameters: query);
  Map<String, dynamic> data = response.data;
  CSResponse resp =
      CSResponse._(data['_status'], data['msg'], jsonEncode(data['data']));
  return resp;
}

Future<CSResponse> httpPost(String path,
    {Object? body, Map<String, dynamic>? query}) async {
  try {
    Response response = await _dio.post(path,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: body);
    Map<String, dynamic> data = response.data;
    CSResponse resp =
        CSResponse._(data['_status'], data['msg'], jsonEncode(data['data']));
    return resp;
  } catch (e) {
    return CSResponse._(1, e.toString(), '');
  }
}
