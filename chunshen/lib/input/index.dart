import 'package:chunshen/base/widget/image/big_image.dart';
import 'package:chunshen/base/widget/image/cs_image.dart';
import 'package:chunshen/global/index.dart';
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
  RouteSettings? settings;

  TextInputPage({this.settings});

  @override
  State<StatefulWidget> createState() {
    return _TextInputState();
  }
}

class _TextInputState extends State<TextInputPage> {
  static const double IMAGE_SIZE = 100;

  InputBorder border = InputBorder.none;
  String? content = '';
  String? comment = '';
  String? tagId = '';
  List<String> imageList = [];
  ImagePicker _picker = ImagePicker();
  // for update
  ExcerptBean? bean;
  bool update = false;
  TagBean? selectedTag;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    handleArgs();
  }

  handleArgs() {
    bean = widget.settings?.arguments as ExcerptBean?;
    if (bean != null) {
      tagId = bean?.tag?.id;
      content = bean?.excerptContent?.content;
      textEditingController.text = content ?? '';
      textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: content?.length ?? 0),
      );
      update = bean?.update ?? false;
      imageList.addAll(bean?.image ?? []);
    }
  }

  Widget getTextField(String hint,
      [bool big = true,
      void Function(String)? onChanged,
      TextEditingController? textEditingController]) {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: TextField(
          controller: textEditingController,
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
      if (Global.isLogin() && BaseModel.isNet()) {
        images = await Future.wait(imageList.map((e) {
          if (e.startsWith('http')) {
            return Future.value(e);
          }
          return UploadOss.upload(e);
        }).toList());
      } else {
        images.addAll(imageList);
      }
    }
    ExcerptUploadBean bean = update
        ? ExcerptUploadBean(tagId, content, comment,
            id: this.bean?.id, image: images)
        : ExcerptUploadBean(tagId, content, comment, image: images);
    CSResponse resp = await ExcerptModel.uploadNewExcerpt(bean);
    hideLoading(context);
    if (resp.status == 0) {
      // success
      Fluttertoast.showToast(msg: update ? '更新成功' : '上传成功');
      bean.tagImage = selectedTag?.head;
      bean.tagName = selectedTag?.content;
      finishPage(context, params: bean);
    } else {
      // fail
      Fluttertoast.showToast(msg: '上传失败，请稍后重试～');
    }
  }

  onTagSelected(Set<String?> tags, List<TagBean> list) {
    if (tags.isEmpty) {
      return;
    }
    tagId = tags.elementAt(0) ?? "";
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
        imageList.add(image.path);
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

  _ocr(XFile? image) async {
    String res = await ocr(context, image);
    if (isEmpty(content)) {
      content = res;
    } else {
      content = content ?? '' + '\n';
    }
    textEditingController.text = content ?? '';
    textEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: content?.length ?? 0),
    );
  }

  _openCamera() async {
    ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    await _ocr(image);
  }

  _openImage() async {
    ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    await _ocr(image);
  }

  Widget buildImageContainer() {
    return Container(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 10,
        children: [
          ...imageList.map((e) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                BigImagePage.openBigImage(context, imageList,
                    initialPage: imageList.indexOf(e));
              },
              child: Stack(
                children: [
                  CSImage.buildImage(e, IMAGE_SIZE, IMAGE_SIZE),
                  Positioned(
                      right: 0,
                      child: GestureDetector(
                        child: Icon(
                          Icons.delete,
                          color: Color(CSColor.white),
                        ),
                        onTap: () {
                          setState(() {
                            imageList.remove(e);
                          });
                        },
                      ))
                ],
              ))),
          if (imageList.length <= 2) buildAddButton()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(CSColor.white),
          title: Text('添加书摘'),
          actions: [
            TextButton(
                onPressed: () {},
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    uploadExcerpt(context);
                  },
                  child: Text(
                    update ? '更新' : '提交',
                    style: TextStyle(
                        fontSize: 16, color: Color(CSColor.lightBlack)),
                  ),
                ))
          ],
        ),
        body: Stack(children: [
          SingleChildScrollView(
              child: Container(
            child: Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  getTextField('这里输入内容', true, (String text) {
                    content = text;
                  }, textEditingController),
                  Row(
                    children: [
                      Expanded(child: SizedBox()),
                      GestureDetector(
                        child: ImageIcon(AssetImage('assets/images/ocr.png'),
                            size: 33),
                        onTap: _openCamera,
                        onLongPress: _openImage,
                      ),
                    ],
                  ),
                  Divider(
                    height: 10,
                    color: Color(CSColor.gray5),
                  ),
                  buildImageContainer(),
                  Divider(
                    height: 10,
                    color: Color(CSColor.gray5),
                  ),
                  if (!update)
                    getTextField('这里来点想法', false, (String text) {
                      comment = text;
                    }),
                ],
              ),
            ),
          )),
          Positioned(
            child: TagWidget(
              onTagSelected,
              multiSelect: false,
              defaultTags: tagId != null ? [tagId!] : [],
              showAdd: true,
            ),
          )
        ]));
  }
}
