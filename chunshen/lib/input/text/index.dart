import 'package:chunshen/style/index.dart';
import 'package:chunshen/tag/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TextInputPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TextInputState();
  }
}

class _TextInputState extends State<TextInputPage> {
  OutlineInputBorder border =
      OutlineInputBorder(borderSide: BorderSide(color: Color(CSColor.gray2)));
  String? content = '';
  String? comment = '';
  String? tagId = '';

  Widget getTextField(String hint,
      [bool big = true, void Function(String)? onChanged]) {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: TextField(
          cursorColor: Color(CSColor.gray3),
          onChanged: onChanged,
          decoration: InputDecoration(
              border: border,
              enabledBorder: border,
              focusedBorder: border,
              hintText: hint),
          maxLines: big ? 10 : 5,
        ));
  }

  uploadExcerpt() {
    if (isEmpty(tagId)) {
      Fluttertoast.showToast(msg: '先选一本书吧～');
    }
  }

  onTagSelected(Set<String> tags) {
     tagId = tags.elementAt(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(backgroundColor: Color(CSColor.white), title: Text('添加书摘')),
        body: Container(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      getTextField('这里输入内容', true, (String text) {
                        content = text;
                      }),
                      getTextField('这里来点想法', false, (String text) {
                        comment = text;
                      }),
                      Container(
                          child: TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () {
                          uploadExcerpt();
                        },
                        child: Text('提交'),
                      ))
                    ],
                  ),
                ),
                Positioned(
                  child: TagWidget(
                    onTagSelected,
                    multiSelect: false,
                  ),
                )
              ],
            )));
  }
}
