import 'dart:io';

import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/model/tag.dart';
import 'package:chunshen/net/index.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/tag/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:chunshen/utils/oss.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class TextInputPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TextInputState();
  }
}

class _TextInputState extends State<TextInputPage> {
  InputBorder border = InputBorder.none;
  String? content = '';
  String? comment = '';
  String? tagId = '';
  List<XFile> imageList = [];
  ImagePicker _picker = ImagePicker();
  final double IMAGE_SIZE = 100;
  // for update
  ExcerptBean? bean;
  bool update = false;
  TagBean? selectedTag;

  handleArgs() {
    bean = getArgs(context) as ExcerptBean?;
    if (bean != null) {
      tagId = bean?.tag?.id;
      content = bean?.excerptContent?.content;
      update = true;
    }
  }

  Widget getTextField(String hint,
      [bool big = true,
      void Function(String)? onChanged,
      String? initText = '']) {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: TextField(
          controller: TextEditingController()..text = initText ?? '',
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
    List<String> images = [];
    if (!isListEmpty(imageList)) {
      images = await Future.wait(
          imageList.map((e) => UploadOss.upload(e.path)).toList());
    }
    ExcerptUploadBean bean = update
        ? ExcerptUploadBean(tagId, content, comment,
            id: this.bean?.id, image: images)
        : ExcerptUploadBean(tagId, content, comment, image: images);
    CSResponse resp = await ExcerptModel.uploadNewExcerpt(bean);
    hideLoading(context);
    if (resp.status == 0) {
      // success
      Fluttertoast.showToast(msg: '上传成功');
      bean.tagImage = selectedTag?.head;
      bean.tagName = selectedTag?.content;
      finishPage(context, params: bean);
    } else {
      // fail
      Fluttertoast.showToast(msg: '上传失败，请稍后重试～');
    }
  }

  onTagSelected(Set<String> tags, List<TagBean> list) {
    tagId = tags.elementAt(0);
    list.forEach((element) {
      if (element.id == tagId) {
        selectedTag = element;
      }
    });
  }

  addImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageList.add(image);
      });
    }
  }

  buildAddButton() {
    return GestureDetector(
        onTap: addImage,
        child: Container(
          width: IMAGE_SIZE,
          height: IMAGE_SIZE,
          color: Color(CSColor.gray),
          child: Icon(Icons.add),
        ));
  }

  Widget buildImageContainer() {
    return Container(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 10,
        children: [
          ...imageList.map((e) => Image.file(
                File(e.path),
                width: IMAGE_SIZE,
                height: IMAGE_SIZE,
                fit: BoxFit.cover,
              )),
          if (imageList.length <= 2) buildAddButton()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    handleArgs();
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(CSColor.white),
            title: Text('添加书摘')),
        body: SingleChildScrollView(
            child: Container(
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
                  }, content),
                  buildImageContainer(),
                  if (!update)
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
                    child: Text(update ? '更新' : '提交'),
                  ))
                ],
              ),
            ),
            Positioned(
              child: TagWidget(
                onTagSelected,
                multiSelect: false,
                defaultTags: tagId != null ? [tagId!] : [],
                showAdd: true,
              ),
            )
          ],
        ))));
  }
}
