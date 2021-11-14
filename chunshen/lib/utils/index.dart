import 'dart:io';

import 'package:chunshen/base/ocr/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

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
