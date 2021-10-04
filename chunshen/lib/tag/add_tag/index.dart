import 'package:chunshen/model/index.dart';
import 'package:chunshen/model/tag.dart';
import 'package:chunshen/net/index.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';

class AddTagPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddTagState();
  }
}

class _AddTagState extends State<AddTagPage> {
  String? content;
  List<TagBean> result = [];
  final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: BorderSide(color: Color(CSColor.gray3)));

  search() async {
    if (content == null) {
      return;
    }
    showLoading(context);
    List<TagBean> tmp = await TagModel.search(content!);
    hideLoading(context);
    setState(() {
      result = tmp;
    });
  }

  Widget buildSearchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: TextField(
          onEditingComplete: search,
          textInputAction: TextInputAction.search,
          cursorColor: Color(CSColor.gray3),
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
            prefixIcon: Icon(
              Icons.search,
              color: Color(CSColor.gray3),
            ),
            border: border,
            enabledBorder: border,
            focusedBorder: border,
          ),
          onChanged: (String val) {
            content = val;
          },
        )),
        // TextButton(onPressed: search, child: Text('搜索'))
      ],
    );
  }

  addTag(TagBean bean) async {
    CSResponse resp = await TagModel.addTag(bean);
    if (CSResponse.success(resp)) {
      toast('添加书籍成功');
      finishPage(context, params: true);
    } else {
      toast('添加书籍失败，请稍后重试～');
    }
  }

  Widget buildResultItem(TagBean bean) {
    return GestureDetector(
        onTap: () {
          addTag(bean);
        },
        child: Row(
          children: [
            Image.network(bean.head ?? '', width: 50, height: 80),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bean.content ?? ''),
                Text(bean.publish ?? ''),
              ],
            ))
          ],
        ));
  }

  Widget buildSearchResult() {
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, i) {
        return buildResultItem(result[i]);
      },
      itemCount: result.length,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(CSColor.white),
            title: Text('添加书籍')),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              buildSearchBar(),
              SizedBox(height: 10),
              buildSearchResult()
            ],
          ),
        ));
  }
}
