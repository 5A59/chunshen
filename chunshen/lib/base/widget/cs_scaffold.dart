import 'package:chunshen/style/index.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget CSScaffold(String title, Widget body, [List<Widget>? actions]) {
  return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(CSColor.lightBlack), //change your color here
        ),
        elevation: 0,
        actions: actions,
        backgroundColor: Color(CSColor.white),
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(CSColor.lightBlack))),
      ),
      body: body);
}
