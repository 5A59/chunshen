import 'package:chunshen/base/widget/cs_scaffold.dart';
import 'package:chunshen/base/widget/image/cs_image.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/model/tag.dart';
import 'package:chunshen/net/index.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddTagPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddTagState();
  }
}

class _AddTagState extends State<AddTagPage> {
  String? content;
  String? head;
  List<TagBean> result = [];
  ImagePicker _picker = ImagePicker();

  final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: BorderSide(width: 0.5, color: Color(CSColor.gray3)));

  void _search() async {
    if (content == null) {
      return;
    }
    showLoading(context);
    List<TagBean> tmp = await TagModel.search(content!);
    hideLoading(context);
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      result = tmp;
    });
  }

  Widget _buildSearchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: TextField(
          onEditingComplete: _search,
          textInputAction: TextInputAction.search,
          cursorColor: Color(CSColor.gray3),
          cursorHeight: 25,
          style: TextStyle(height: 1.4),
          autofocus: true,
          decoration: InputDecoration(
            hintText: '输入书名搜索',
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

  _addTag(TagBean bean, {Function(bool)? callback}) async {
    CSResponse resp = await TagModel.addTag(bean);
    if (CSResponse.success(resp)) {
      toast('添加书籍成功');
      callback?.call(true);
      finishPage(context, params: true);
    } else if (resp.status == 1) {
      toast(resp.msg);
      callback?.call(true);
    } else {
      toast('添加书籍失败，请稍后重试～');
      callback?.call(true);
    }
  }

  Widget _buildResultItem(TagBean bean) {
    return GestureDetector(
        onTap: () {
          _addTag(bean);
        },
        child: Column(
          children: [
            Row(
              children: [
                CSImage.buildImage(bean.head, 50, 80),
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
            ),
            SizedBox(
              height: 10,
            )
          ],
        ));
  }

  Widget _buildSearchResult() {
    return Expanded(
        child: GestureDetector(
      child: ListView.builder(
        itemBuilder: (context, i) {
          return _buildResultItem(result[i]);
        },
        itemCount: result.length,
      ),
      onTap: () => hideKeyboard(context),
    ));
  }

  void _addTagBySelf() {
    addOrUpdateTag(context, false, (TagBean newTag) {
      _addTag(newTag);
      return true;
    }, null);
  }

  @override
  Widget build(BuildContext context) {
    return CSScaffold(
        '添加书籍',
        Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                _buildSearchBar(),
                SizedBox(height: 10),
                _buildSearchResult()
              ],
            )),
        [
          TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all(Color(CSColor.black))),
              onPressed: _addTagBySelf,
              child: Text('手动添加'))
        ]);
  }
}
