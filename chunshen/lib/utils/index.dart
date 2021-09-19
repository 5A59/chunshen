
import 'package:flutter/material.dart';

openPage(BuildContext context, page, {params}) {
  return Navigator.pushNamed(context, page, arguments: params);
}

bool isEmpty(String? content) {
  return content?.isEmpty ?? true;
}