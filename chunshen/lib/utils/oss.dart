import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class OssUtils {}

class UploadOss {
  static String _ossAccessKeyId = 'LTAI5tHmDpU6SsCtopym4bwT';

  static String _ossAccessKeySecret = 'hJnC1oLDEyHIBTp98cyig1kPWcqGa7';
  // oss设置的bucket的名字
  static String _bucket = 'chunshen-cc';
  // 发送请求的 url,根据你自己设置的是哪个城市的
  static String _url = 'https://$_bucket.oss-cn-hongkong.aliyuncs.com';

  // 过期时间
  static String _expiration = '2225-01-01T12:00:00.000Z';

  static Map<String, dynamic> getAccessParams() {
    String policyText =
        '{"expiration": "$_expiration","conditions": [{"bucket": "$_bucket" },["content-length-range", 0, 1048576000]]}';
    // 获取签名
    String signature = getSignature(policyText);

    return {
      'policy': getSplicyBase64(policyText),
      'Expires': DateTime.parse(_expiration).millisecondsSinceEpoch / 1000,
      'OSSAccessKeyId': _ossAccessKeyId,
      'success_action_status': '200', //让服务端返回200，不然，默认会返回204
      'signature': signature,
    };
  }

  /**
   * @params file 要上传的文件对象
   * @params rootDir 阿里云oss设置的根目录文件夹名字
   * @param fileType 文件类型例如jpg,mp4等
   * @param callback 回调函数我这里用于传cancelToken，方便后期关闭请求
   * @param onSendProgress 上传的进度事件
   */
  static Future<String> upload(String path,
      {String rootDir = 'test',
      String? fileType,
      Function? callback,
      Function? onSendProgress}) async {
    try {
      String policyText =
          '{"expiration": "$_expiration","conditions": [{"bucket": "$_bucket" },["content-length-range", 0, 1048576000]]}';

      // 获取签名
      String signature = getSignature(policyText);

      BaseOptions options = new BaseOptions();
      options.responseType = ResponseType.plain;

      //创建dio对象
      Dio dio = new Dio(options);
      // 生成oss的路径和文件名我这里目前设置的是 test/20201229/test.mp4
      String pathName =
          '$rootDir/${getDate()}/${getRandom(12)}.${fileType == null ? getFileType(path) : fileType}';

      // 请求参数的form对象
      Map<String, dynamic> params = getAccessParams();
      params['key'] = pathName;
      params['contentType'] = 'multipart/form-data';
      params['file'] = MultipartFile.fromFileSync(path);
      FormData data = new FormData.fromMap(params);
      // FormData data = new FormData.fromMap({
      //   'key': pathName,
      //   'policy': getSplicyBase64(policyText),
      //   'Expires': DateTime.parse(_expiration).millisecondsSinceEpoch / 1000,
      //   'OSSAccessKeyId': _ossAccessKeyId,
      //   'success_action_status': '200', //让服务端返回200，不然，默认会返回204
      //   'signature': signature,
      //   'contentType': 'multipart/form-data',
      //   'file': MultipartFile.fromFileSync(path),
      // });

      Response response;
      CancelToken uploadCancelToken = CancelToken();
      callback?.call(uploadCancelToken);

      try {
        // 发送请求
        response = await dio
            .post(_url, data: data, cancelToken: uploadCancelToken,
                onSendProgress: (int count, int data) {
          onSendProgress?.call(count, data);
        });
        // 成功后返回文件访问路径
        return '$_url/$pathName';
      } catch (e) {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  /*
  * 生成固定长度的随机字符串
  * */
  static String getRandom(int num) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String left = '';
    for (var i = 0; i < num; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  /*
  * 根据图片本地路径获取图片名称
  * */
  static String getImageNameByPath(String filePath) {
    // ignore: null_aware_before_operator
    return filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);
  }

  /**
   * 获取文件类型
   */
  static String getFileType(String path) {
    List<String> array = path.split('.');
    return array[array.length - 1];
  }

  /// 获取日期
  static String getDate() {
    DateTime now = DateTime.now();
    return '${now.year}${now.month}${now.day}';
  }

  // 获取plice的base64
  static getSplicyBase64(String policyText) {
    //进行utf8编码
    List<int> policyText_utf8 = utf8.encode(policyText);
    //进行base64编码
    String policy_base64 = base64.encode(policyText_utf8);
    return policy_base64;
  }

  /// 获取签名
  static String getSignature(String policyText) {
    //进行utf8编码
    List<int> policyText_utf8 = utf8.encode(policyText);
    //进行base64编码
    String policy_base64 = base64.encode(policyText_utf8);
    //再次进行utf8编码
    List<int> policy = utf8.encode(policy_base64);
    //进行utf8 编码
    List<int> key = utf8.encode(_ossAccessKeySecret);
    //通过hmac,使用sha1进行加密
    List<int> signature_pre = Hmac(sha1, key).convert(policy).bytes;
    //最后一步，将上述所得进行base64 编码
    String signature = base64.encode(signature_pre);
    return signature;
  }
}
