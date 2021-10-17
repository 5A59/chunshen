import 'dart:io';

import 'package:chunshen/base/ocr/index.dart';
import 'package:chunshen/config.dart';
import 'package:chunshen/main/index.dart';
import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class OperationBar extends StatefulWidget {
  final IOperationListener? listener;
  OperationBar(this.listener);

  @override
  State<StatefulWidget> createState() {
    return _OperationBarState(listener: listener);
  }
}

class _OperationBarState extends State<OperationBar> {
  final IOperationListener? listener;
  _OperationBarState({this.listener});

  List<Widget> getIconWithSpace(IconData iconData, {void Function()? onTap}) {
    return [
      GestureDetector(
        child: Icon(
          iconData,
          size: 35,
        ),
        onTap: onTap,
      ),
      SizedBox(width: 20)
    ];
  }

  _openTextInput() async {
    var res = await openPage(context, PAGE_TEXT_INPUT);
    if (res != null) {
      listener?.onExcerptUploadFinished();
    }
  }

  _openImage() async {
    ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File? file = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'OCR',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (file != null) {
        showLoading(context);
        String res = await OcrUtils().ocr(file);
        hideLoading(context);
        ExcerptBean bean = ExcerptBean(
            null, null, ExcerptContentBean(res, null), [], [], false);
        var pageRes = await openPage(context, PAGE_TEXT_INPUT, params: bean);
        if (pageRes != null) {
          listener?.onExcerptUploadFinished();
        }
      }
    }
  }

  _openManageTag() async {
    var res = await openPage(context, PAGE_MANAGE_TAG);
    if (res == true) {
      listener?.onTagChanged();
    }
  }

  _openLogin() async {
    var res = await openPage(context, PAGE_LOGIN);
    // if (res == true) {
    //   listener?.onTagChanged();
    // }
  }

  _onMenuSelected(String value) {
    switch (value) {
      case 'book':
        _openManageTag();
        break;
      case 'login':
        _openLogin();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        color: Color(CSColor.white),
        child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                ...getIconWithSpace(Icons.keyboard, onTap: _openTextInput),
                ...getIconWithSpace(Icons.photo_camera, onTap: _openImage),
                ...getIconWithSpace(Icons.publish),
                Expanded(child: SizedBox()),
                PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(value: 'book', child: Text('管理书籍')),
                      PopupMenuItem(value: 'login', child: Text('登录'))
                    ];
                  },
                  icon: Icon(
                    Icons.tune,
                    size: 35,
                  ),
                  onSelected: _onMenuSelected,
                ),
              ],
            )));
  }
}
