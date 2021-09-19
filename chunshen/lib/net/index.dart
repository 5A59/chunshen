import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const DEBUG = kDebugMode;
const DEBUG_URL = 'http://127.0.0.1:3000/api';
const URL = '';

var _options = BaseOptions(baseUrl: DEBUG ? DEBUG_URL : URL);

Dio _dio = Dio(_options);

class CSResponse {
  int status = 0;
  String msg = '';
  String data = '';

  CSResponse._(this.status, this.msg, this.data);
}

Future<CSResponse> httpGet(String path, {Map<String, dynamic>? query}) async {
  Response response = await _dio.get(path, queryParameters: query);
  Map<String, dynamic> data = response.data;
  CSResponse resp =
      CSResponse._(data['status'], data['msg'], jsonEncode(data['data']));
  return resp;
}

Future<CSResponse> httpPost(String path, {Map<String, dynamic>? body, Map<String, dynamic>? query}) async {
  Response response = await _dio.post(path,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
      data: jsonEncode(body));
  Map<String, dynamic> data = response.data;
  CSResponse resp =
      CSResponse._(data['status'], data['msg'], jsonEncode(data['data']));
  return resp;
}
