import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class OcrUtils {
  String _baiduApi = "https://aip.baidubce.com/oauth/2.0/token?";
  String _baiduRestApi =
      "https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic?";
  String _baiduGrantType = "client_credentials";
  String _baiduClientId =
      "oceMj6NqhLaRaM72Eo1Ce0bB"; //百度ocr api的 clientId,请自行申请，这个已经失效
  String _baiduClientSecret =
      "fEDKrAA1oYZ0fFdmK4WPzzMbHtATHRNU"; //百度ocr api的 Secret，这个已经失效

  Future<String> ocr(File file) async {
    List<int> byteList = file.readAsBytesSync();

    String base64Image = base64Encode(byteList); //base 64

    Dio dio = new Dio();
    String tokenUrl = _baiduApi +
        "grant_type=" +
        _baiduGrantType +
        "&client_id=" +
        _baiduClientId +
        "&client_secret=" +
        _baiduClientSecret;

    Response response = await dio.post(tokenUrl);
    String accessToken = response.data['access_token'].toString();
    String ocrUrl = _baiduRestApi + "access_token=" + accessToken;
    Response res = await dio.post(ocrUrl,
        data: {"image": base64Image},
        options: new Options(contentType: "application/x-www-form-urlencoded"));
    int wordsNum = int.parse(res.data["words_result_num"].toString());
    print(res.data.toString());
    List<String> ocrContent = <String>[];
    if (wordsNum > 0) {
      var array = res.data["words_result"];
      for (var ar in array) {
        ocrContent.add(ar["words"].toString());
        // ocrContent += ar["words"].toString()+"\n";
        print(ar["words"].toString());
      }
    }
    return ocrContent.join("");
  }
}
