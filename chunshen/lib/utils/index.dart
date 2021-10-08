import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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

bool isListEmpty(List? list) {
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

Object? getArgs(BuildContext context) {
  return ModalRoute.of(context)!.settings.arguments;
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
