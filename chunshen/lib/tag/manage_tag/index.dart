import 'package:chunshen/model/tag.dart';
import 'package:chunshen/style/index.dart';
import 'package:flutter/material.dart';

class ManageTagPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ManageTagState();
  }
}

class _ManageTagState extends State<ManageTagPage> {
  String? content;
  List<TagBean> result = [];
  final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: BorderSide(color: Color(CSColor.gray3)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(CSColor.white),
            title: Text('管理书籍')),
        body: Container());
  }
}
