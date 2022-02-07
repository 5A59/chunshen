import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/net/index.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';

import '../config.dart';

class MoreMenu {
  ExcerptBean? bean;
  BuildContext context;
  IMenuListener listener;
  MoreMenu(this.bean, this.context, this.listener);

  PopupMenuItem<String> _getPopItem(String text, String value) {
    return PopupMenuItem<String>(
      child: Text(text),
      value: value,
    );
  }

  Widget buildMoreMenu() {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return [
          // _getPopItem('分享', 'share'),
          _getPopItem('复制', 'copy'),
          _getPopItem('评论', 'comment'),
          _getPopItem('编辑', 'edit'),
          _getPopItem('删除', 'delete'),
        ];
      },
      icon: Icon(
        Icons.more_horiz,
        color: Color(CSColor.lightBlack),
      ),
      onSelected: onPopupMenuSelected,
    );
  }

  onPopupMenuSelected(String value) {
    switch (value) {
      case 'share':
        break;
      case 'copy':
        copyToClipboard(bean?.excerptContent?.content);
        break;
      case 'comment':
        _triggerCommentInput(true);
        break;
      case 'edit':
        _triggerEdit();
        break;
      case 'delete':
        _triggerDelete();
        break;
      default:
    }
  }

  _triggerEdit() async {
    bean?.update = true;
    ExcerptUploadBean? uploadBean =
        await openPage(context, PAGE_TEXT_INPUT, params: bean);
    if (uploadBean != null) {
      listener.onEdit(uploadBean);
    }
  }

  _triggerCommentInput(show) {
    listener.onComment(show);
  }

  _triggerDelete() {
    showNorlmalDialog(context, '提示', '确认删除此文摘吗？', '取消', '确认', null, () async {
      showLoading(context);
      CSResponse resp = await DeleteModel.deleteExcerpt(bean?.id);
      hideLoading(context);
      if (CSResponse.success(resp)) {
        toast('删除成功');
        listener.onDeleteSuccess();
      } else {
        toast('删除失败，请稍后重试～');
      }
    });
  }

  Widget buildCommentInput() {
    InputBorder border = InputBorder.none;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(CSColor.gray2), width: 0.5),
          borderRadius: BorderRadius.circular(3)),
      child: Column(
        children: [
          TextField(
            onChanged: (String content) {
              listener.onCommentChanged(content);
            },
            cursorHeight: 25,
            cursorColor: Color(CSColor.gray3),
            style: TextStyle(fontSize: 15, height: 1.5),
            autofocus: true,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                border: border,
                enabledBorder: border,
                focusedBorder: border,
                hintText: '评论'),
            maxLines: 3,
            minLines: 1,
          ),
          Row(
            children: [
              Spacer(),
              TextButton(
                  onPressed: () {
                    listener.onComment(false);
                  },
                  child: Text(
                    '取消',
                    style: TextStyle(color: Color(CSColor.lightBlack)),
                  )),
              TextButton(
                  onPressed: listener.onCommentUpload,
                  child: Text(
                    '提交',
                    style: TextStyle(color: Color(CSColor.lightBlack)),
                  ))
            ],
          )
        ],
      ),
    );
  }
}

abstract class IMenuListener {
  onDeleteSuccess();
  onEdit(ExcerptUploadBean? bean);
  onComment(bool show);
  onCommentChanged(String content);
  onCommentUpload();
}
