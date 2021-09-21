import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/net/index.dart';
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

  uploadExcerpt(BuildContext context) async {
    if (isEmpty(tagId)) {
      toast('先选一本书吧～');
      return;
    }
    if (isEmpty(content)) {
      toast('先加点内容吧～');
      return;
    }
    showLoading(context);
    ExcerptUploadBean bean = ExcerptUploadBean(tagId, content, comment);
    CSResponse resp = await ExcerptModel.uploadNewExcerpt(bean);
    hideLoading(context);
    if (resp.status == 0) {
      // success
      Fluttertoast.showToast(msg: '上传成功');
      // Navigator.pop(context);
    } else {
      // fail
      Fluttertoast.showToast(msg: '上传失败，请稍后重试～');
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
                          uploadExcerpt(context);
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
