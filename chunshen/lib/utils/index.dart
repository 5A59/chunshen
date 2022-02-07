import 'dart:io';

import 'package:chunshen/base/ocr/index.dart';
import 'package:chunshen/base/widget/image/cs_image.dart';
import 'package:chunshen/model/tag.dart';
import 'package:chunshen/style/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

const MethodChannel _channel = const MethodChannel('ext_storage');

openPage(BuildContext context, page, {params}) {
  return Navigator.pushNamed(context, page, arguments: params);
}

openPageRaw(BuildContext context, Route route) {
  return Navigator.push(context, route);
}

finishPage(BuildContext context, {params}) {
  Navigator.pop(context, params);
}

bool isEmpty(String? content) {
  return content?.isEmpty ?? true;
}

bool isListEmpty(Iterable? list) {
  return list == null || list.isEmpty;
}

showLoading(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showMessageDialog(BuildContext context, String msg) {
  AlertDialog alert = AlertDialog(
    content: Text(msg),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

hideDialog(BuildContext context) {
  Navigator.pop(context);
}

hideLoading(BuildContext context) {
  Navigator.pop(context);
}

showNorlmalDialog(BuildContext context, String title, String content,
    String button1, String button2, Function? btn1Click, Function? btn2Click) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text(button1),
            onPressed: () {
              btn1Click?.call();
              Navigator.of(context).pop();
            }, //关闭对话框
          ),
          TextButton(
            child: Text(button2),
            onPressed: () {
              btn2Click?.call();
              Navigator.of(context).pop(true); //关闭对话框
            },
          ),
        ],
      );
    },
  );
}

toast(String msg) {
  Fluttertoast.showToast(msg: msg);
}

formatTime(int? time) {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd hh:mm');
  if (time != null) {
    return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  } else {
    return '';
  }
}

void showMenuAtPosition(
    BuildContext context, Offset position, List<PopupMenuItem> items,
    {Function? onCanceled, Function? onSelected}) {
  RenderBox? overlay =
      Overlay.of(context)?.context.findRenderObject() as RenderBox;
  showMenu(
          context: context,
          position: RelativeRect.fromRect(
              position & Size(40, 40), // smaller rect, the touch area
              Offset.zero & overlay.size // Bigger rect, the entire screen
              ),
          items: items)
      .then((value) {
    if (value == null) {
      onCanceled?.call();
      return null;
    }
    onSelected?.call(value);
  });
}

void copyToClipboard(content, {bool showToast = true}) {
  Clipboard.setData(ClipboardData(text: content));
  if (showToast) {
    toast('已复制到剪切板');
  }
}

String generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  return digest.toString();
}

Iterable<T> pickRandomItems<T>(List<T> items, int count) =>
    (items.toList()..shuffle()).take(count);

csJsonDecode(String content) {
  if (isEmpty(content)) {
    return jsonDecode('{}');
  }
  return jsonDecode(content);
}

Future<String> ocr(BuildContext context, XFile? image) async {
  String res = "";
  if (image != null) {
    File? file = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'OCR',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (file != null) {
      showLoading(context);
      res = await OcrUtils().ocr(file);
      hideLoading(context);
    }
  }
  return res;
}

_addImage(Function? callback) async {
  ImagePicker _picker = ImagePicker();
  XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    callback?.call(image.path);
  }
}

Widget _buildImage(String head, Function? callback) {
  return GestureDetector(
      onTap: () {
        _addImage(callback);
      },
      child: Column(
        children: [
          isEmpty(head)
              ? Container(
                  width: 70,
                  height: 100,
                  color: Color(CSColor.gray),
                  child: Icon(Icons.add))
              : CSImage.buildImage(head, 70, 100),
        ],
      ));
}

void addOrUpdateTag(BuildContext context, bool update,
    bool Function(TagBean)? callback, TagBean? oldTag) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        String head = oldTag?.head ?? '';
        String? content = oldTag?.content;
        return StatefulBuilder(
          builder: (context, setState) {
            AlertDialog dialog = AlertDialog(
              title: Text(update ? '编辑书籍' : '添加书籍'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildImage(head, (path) {
                    setState(() {
                      head = path;
                    });
                  }),
                  TextField(
                    cursorColor: Color(CSColor.gray3),
                    cursorHeight: 25,
                    style: TextStyle(height: 1.4),
                    autofocus: true,
                    decoration: InputDecoration(hintText: '输入书名'),
                    controller: TextEditingController()..text = content ?? '',
                    onChanged: (String value) {
                      content = value;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        if (!isEmpty(content)) {
                          bool? res = callback
                              ?.call(TagBean('', head, content, '', true));
                          if (res == true) {
                            hideDialog(context);
                          }
                        }
                      },
                      child: Text(
                        '确认',
                        style: TextStyle(color: Color(CSColor.lightBlack)),
                      ))
                ],
              ),
            );
            return dialog;
          },
        );
      });
}

Future<String> getExternalStoragePublicDirectory(String type) async {
  if (!Platform.isAndroid) {
    throw UnsupportedError("Only android supported");
  }
  return await _channel
      .invokeMethod('getExternalStoragePublicDirectory', {"type": type});
}

Future<String> writeToDownload(String path, String name, String type) async {
  return await _channel.invokeMethod(
      'writeToDownload', {'path': path, "name": name, "type": type});
}
