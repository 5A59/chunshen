import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

openPage(BuildContext context, page, {params}) {
  return Navigator.pushNamed(context, page, arguments: params);
}

bool isEmpty(String? content) {
  return content?.isEmpty ?? true;
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

hideLoading(BuildContext context) {
  Navigator.pop(context);
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
