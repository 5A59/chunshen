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
  final IOperationListener? listener;
  OperationBar(this.listener);

  @override
  State<StatefulWidget> createState() {
    return _OperationBarState(listener: listener);
  }
}

class _OperationBarState extends State<OperationBar> {
  final IOperationListener? listener;
  String? username;
  _OperationBarState({this.listener});

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
            ? ImageIcon(AssetImage(iconData), size: 33)
            : Icon(
                iconData,
                size: 35,
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
      listener?.onExcerptUploadFinished();
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
      listener?.onExcerptUploadFinished();
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
    if (res == true) {
      listener?.onTagChanged();
    }
  }

  _openLogin() async {
    var res = await openPage(context, PAGE_LOGIN);
  }

  _openUserInfo() async {
    openPage(context, PAGE_USER_INFO);
  }

  _exportExcerpts() async {
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
        await fileServer.reInit();
        listener?.onExcerptUploadFinished();
      } else {
        showMessageDialog(context, '导入失败');
      }
    } else {
      showMessageDialog(context, '导入失败');
    }
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
                    onTap: _openCamera, onLongPress: _openImage),
                Expanded(
                    child: GestureDetector(
                        onTap: _openTextInput,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(CSColor.gray1))),
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            '点此输入',
                            style: TextStyle(color: Color(CSColor.gray2)),
                          ),
                        ))),
                PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(value: 'export', child: Text('导出书摘')),
                      PopupMenuItem(value: 'import', child: Text('导入书摘')),
                      PopupMenuItem(value: 'book', child: Text('管理书籍')),
                      PopupMenuItem(
                          value: 'login',
                          child: Text(isEmpty(username) ? '登录' : username!))
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
