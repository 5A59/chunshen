import 'package:chunshen/config.dart';
import 'package:chunshen/global/index.dart';
import 'package:chunshen/main/index.dart';
import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/fileserver/index.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OperationBar extends StatefulWidget {
  final List<IOperationListener>? listeners;
  OperationBar(this.listeners);

  @override
  State<StatefulWidget> createState() {
    return _OperationBarState(listeners: listeners);
  }
}

class _OperationBarState extends State<OperationBar> {
  final List<IOperationListener>? listeners;
  String? username;
  _OperationBarState({this.listeners});

  @override
  void initState() {
    Global.addLoginListener(() {
      setState(() {
        username = Global.username;
      });
    });
    super.initState();
  }

  List<Widget> getIconWithSpace(var iconData,
      {void Function()? onTap, void Function()? onLongPress}) {
    return [
      GestureDetector(
        child: iconData is String
            ? ImageIcon(
                AssetImage(iconData),
                size: 33,
                color: Color(CSColor.yellow),
              )
            : Icon(
                iconData,
                size: 35,
                color: Color(CSColor.yellow),
              ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
      SizedBox(width: 20)
    ];
  }

  _openTextInput() async {
    var res = await openPage(context, PAGE_TEXT_INPUT);
    if (res != null) {
      listeners?.forEach((element) {
        element.onExcerptUploadFinished();
      });
    }
  }

  _ocr(XFile? image) async {
    String res = await ocr(context, image);
    if (isEmpty(res)) {
      return;
    }
    ExcerptBean bean = ExcerptBean(
        null, null, null, ExcerptContentBean(res, null), [], [], false);
    var pageRes = await openPage(context, PAGE_TEXT_INPUT, params: bean);
    if (pageRes != null) {
      listeners?.forEach((element) {
        element.onExcerptUploadFinished();
      });
    }
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

  _openManageTag() async {
    var res = await openPage(context, PAGE_MANAGE_TAG);
    if (res == 1) {
      listeners?.forEach((element) {
        element.onTagChanged();
      });
    } else if (res == 2) {
      listeners?.forEach((element) {
        element.onExcerptUploadFinished();
      });
    }
  }

  _openLogin() async {
    var res = await openPage(context, PAGE_LOGIN);
  }

  _openUserInfo() async {
    openPage(context, PAGE_USER_INFO);
  }

  _exportExcerpts() async {
    // await Permission.manageExternalStorage.request();
    String res = await FileServer().exportExcerpts();
    showMessageDialog(context, !isEmpty(res) ? '导出成功：$res' : '导出失败');
  }

  _importExcerpts() async {
    FileServer fileServer = FileServer();
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String? path = result.files.single.path;
      if (isEmpty(path)) {
        showMessageDialog(context, '导入失败');
        return;
      }
      bool res = await fileServer.importExcerpts(path!);
      if (res) {
        showMessageDialog(context, '导入成功');
        listeners?.forEach((element) {
          element.onExcerptUploadFinished();
        });
      } else {
        showMessageDialog(context, '导入失败');
      }
    } else {
      showMessageDialog(context, '请选择文件导入～');
    }
  }

  _openGuide() async {
    openPage(context, PAGE_GUIDE);
  }

  _onMenuSelected(String value) {
    switch (value) {
      case 'book':
        _openManageTag();
        break;
      case 'login':
        if (isEmpty(Global.username)) {
          _openLogin();
        } else {
          _openUserInfo();
        }
        break;
      case 'export':
        _exportExcerpts();
        break;
      case 'import':
        _importExcerpts();
        break;
      case 'guide':
        _openGuide();
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
                ...getIconWithSpace('assets/images/ocr.png',
                    // ...getIconWithSpace(Icons.camera,
                    onTap: _openCamera,
                    onLongPress: _openImage),
                Expanded(
                    child: GestureDetector(
                        onTap: _openTextInput,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Color(CSColor.gray1))),
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            '点此输入',
                            style: TextStyle(
                                color: Color(CSColor.gray2),
                                fontWeight: FontWeight.bold),
                          ),
                        ))),
                PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                          value: 'export',
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.file_download,
                                color: Color(CSColor.yellow),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('导出书摘'),
                            ],
                          )),
                      PopupMenuItem(
                          value: 'import',
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.file_upload,
                                  color: Color(CSColor.yellow)),
                              SizedBox(
                                width: 10,
                              ),
                              Text('导入书摘'),
                            ],
                          )),
                      PopupMenuItem(
                          value: 'book',
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.book,
                                color: Color(CSColor.yellow),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('管理书籍'),
                            ],
                          )),
                      PopupMenuItem(
                          value: 'guide',
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.find_in_page,
                                  color: Color(CSColor.yellow)),
                              SizedBox(
                                width: 10,
                              ),
                              Text('使用指南'),
                            ],
                          )),
                      // PopupMenuItem(
                      //     value: 'login',
                      //     child: Text(isEmpty(username) ? '登录' : username!))
                    ];
                  },
                  icon: Icon(
                    Icons.tune,
                    color: Color(CSColor.yellow),
                    size: 35,
                  ),
                  onSelected: _onMenuSelected,
                ),
              ],
            )));
  }
}
