import 'dart:math';

import 'package:chunshen/base/widget/image/big_image.dart';
import 'package:chunshen/base/widget/image/cs_image.dart';
import 'package:chunshen/config.dart';
import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/model/tag.dart';
import 'package:chunshen/net/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:chunshen/style/index.dart';

class ExcerptCommentItem extends StatefulWidget {
  final ExcerptBean? bean;
  final List<ExcerptCommentBean>? comment;
  final Function? onCommentDeleted;

  ExcerptCommentItem(this.bean, this.comment, {this.onCommentDeleted});

  @override
  _ExcerptCommentItemState createState() => _ExcerptCommentItemState();
}

class _ExcerptCommentItemState extends State<ExcerptCommentItem> {
  Offset? _tapPosition;

  _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  _deleteComment(BuildContext context, int i) {
    showNorlmalDialog(context, '提示', '确认删除此评论吗？', '取消', '确认', null, () async {
      showLoading(context);
      CSResponse resp = await DeleteModel.deleteComment(
          widget.bean?.id, widget.comment?[i].id);
      hideLoading(context);
      if (CSResponse.success(resp)) {
        toast('删除成功');
        setState(() {
          widget.comment?.removeAt(i);
        });
        // widget.onCommentDeleted?.call(widget.comment?[i]);
      } else {
        toast('删除失败，请稍后重试～');
      }
    });
  }

  _showCommentMenu(BuildContext context, int i) async {
    if (_tapPosition != null) {
      showMenuAtPosition(context, _tapPosition!, [
        PopupMenuItem(
          value: 'copy',
          child: Text("复制"),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text("删除"),
        ),
      ], onSelected: (value) {
        if (value == 'delete') {
          _deleteComment(context, i);
        } else if (value == 'copy') {
          copyToClipboard(widget.comment?[i].content);
        }
      });
    }
  }

  Widget buildItem(BuildContext context, int i) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: _storePosition,
        onLongPress: () {
          _showCommentMenu(context, i);
        },
        child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (i > 0)
                  Divider(
                    height: 15,
                    color: Color(CSColor.gray1),
                  ),
                Text(widget.comment?[i].content ?? ''),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      formatTime(widget.comment?[i].time) ?? '',
                      style: TextStyle(color: Color(CSColor.gray2)),
                    )
                  ],
                )
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return (widget.comment?.length ?? 0) > 0
        ? Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ListView.builder(
              shrinkWrap: true,
              physics: new NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return buildItem(context, i);
              },
              itemCount: widget.comment?.length ?? 0,
            ),
            decoration: BoxDecoration(color: Color(CSColor.gray)))
        : Container();
  }
}

class ExcerptContentItem extends StatefulWidget {
  final ExcerptBean? bean;
  final Function? onCommentAdded;
  final Function? onExcerptDeleted;

  ExcerptContentItem(this.bean, this.onCommentAdded, this.onExcerptDeleted);

  @override
  State<StatefulWidget> createState() {
    return ExcerptContentItemState();
  }
}

class ExcerptContentItemState extends State<ExcerptContentItem> {
  final InputBorder border = InputBorder.none;
  bool showCommentInput = false;
  String? comment = '';

  PopupMenuItem<String> getPopItem(String text, String value) {
    return PopupMenuItem<String>(
      child: Text(text),
      value: value,
    );
  }

  handleShare() {}

  Widget buildMoreMenu() {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return [
          getPopItem('分享', 'share'),
          getPopItem('复制', 'copy'),
          getPopItem('评论', 'comment'),
          getPopItem('编辑', 'edit'),
          getPopItem('删除', 'delete'),
        ];
      },
      icon: Icon(
        Icons.adaptive.more,
        color: Color(CSColor.blue),
      ),
      onSelected: onPopupMenuSelected,
    );
  }

  onPopupMenuSelected(String value) {
    switch (value) {
      case 'share':
        break;
      case 'copy':
        copyToClipboard(widget.bean?.excerptContent?.content);
        break;
      case 'comment':
        triggerCommentInput(true);
        break;
      case 'edit':
        triggerEdit();
        break;
      case 'delete':
        triggerDelete();
        break;
      default:
    }
  }

  triggerDelete() {
    showNorlmalDialog(context, '提示', '确认删除此文摘吗？', '取消', '确认', null, () async {
      showLoading(context);
      CSResponse resp = await DeleteModel.deleteExcerpt(widget.bean?.id);
      hideLoading(context);
      if (CSResponse.success(resp)) {
        toast('删除成功');
        widget.onExcerptDeleted?.call();
      } else {
        toast('删除失败，请稍后重试～');
      }
    });
  }

  triggerCommentInput(show) {
    setState(() {
      showCommentInput = show;
    });
  }

  triggerEdit() async {
    widget.bean?.update = true;
    ExcerptUploadBean? uploadBean =
        await openPage(context, PAGE_TEXT_INPUT, params: widget.bean);
    if (uploadBean != null) {
      refreshExcerpt(uploadBean);
    }
  }

  refreshExcerpt(ExcerptUploadBean uploadBean) {
    setState(() {
      widget.bean?.excerptContent?.content = uploadBean.content;
      widget.bean?.tag?.id = uploadBean.tagId;
      widget.bean?.image = uploadBean.image;
      if (!isEmpty(uploadBean.tagName)) {
        widget.bean?.tag?.content = uploadBean.tagName;
      }
      if (!isEmpty(uploadBean.tagImage)) {
        widget.bean?.tag?.head = uploadBean.tagImage;
      }
    });
  }

  uploadComment() async {
    if (isEmpty(comment)) {
      triggerCommentInput(false);
      return;
    }
    ExcerptCommentBean? commentBean =
        await CommentModel.uploadNewComment(widget.bean?.id, comment);
    if (commentBean != null) {
      toast('提交成功');
      triggerCommentInput(false);
      widget.onCommentAdded?.call(commentBean);
    } else {
      toast('提交失败，请稍后重试～');
    }
  }

  Widget buildCommentInput() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(CSColor.gray2), width: 0.5),
          borderRadius: BorderRadius.circular(3)),
      child: Column(
        children: [
          TextField(
            onChanged: (String content) {
              comment = content;
            },
            style: TextStyle(
              fontSize: 15,
            ),
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
                    triggerCommentInput(false);
                  },
                  child: Text('取消')),
              TextButton(onPressed: uploadComment, child: Text('提交'))
            ],
          )
        ],
      ),
    );
  }

  bool hasImage(ExcerptBean? bean) {
    return bean?.image != null && (bean?.image!.length ?? 0) > 0;
  }

  Widget buildImage(List<String> image) {
    return Wrap(
      spacing: 10,
      children: [
        ...image
            .map((e) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  BigImagePage.openBigImage(context, image,
                      initialPage: image.indexOf(e));
                },
                child: CSImage.buildImage(e, 100, 100)))
            .toList()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TagBean? tag = widget.bean?.tag;
    ExcerptContentBean? bean = widget.bean?.excerptContent;
    return bean != null
        ? Column(
            children: [
              Text(
                tag?.content ?? '',
                style: TextStyle(
                    fontSize: 18,
                    color: Color(CSColor.blue),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onLongPress: () {
                  copyToClipboard(bean.content);
                },
                child: Text(bean.content ?? ''),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    formatTime(bean.time) ?? '',
                    style: TextStyle(color: Color(CSColor.gray2)),
                  ),
                  buildMoreMenu()
                ],
              ),
              if (hasImage(widget.bean)) SizedBox(height: 15),
              if (hasImage(widget.bean)) buildImage(widget.bean?.image ?? []),
              if (hasImage(widget.bean)) SizedBox(height: 15),
              showCommentInput ? buildCommentInput() : Container()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          )
        : Spacer();
  }
}

class ExcerptItem extends StatefulWidget {
  final ExcerptBean bean;
  final Function? onExcerptDelete;
  ExcerptItem(this.bean, {this.onExcerptDelete});

  @override
  State<StatefulWidget> createState() {
    return ExcerptItemState();
  }
}

class ExcerptItemState extends State<ExcerptItem> {
  onCommentAdded(ExcerptCommentBean comment) {
    setState(() {
      widget.bean.comment.add(comment);
    });
  }

  onCommentDeleted(ExcerptCommentBean comment) {
    setState(() {
      widget.bean.comment.remove(comment);
    });
  }

  onExcerptDeleted() {
    widget.onExcerptDelete?.call();
  }

  @override
  Widget build(BuildContext context) {
    ExcerptBean bean = widget.bean;
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CSImage.buildImage(bean.tag?.head, 50, 80),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: ExcerptContentItem(
                      bean, onCommentAdded, onExcerptDeleted),
                )
              ],
            ),
            SizedBox(height: 15),
            Container(
                padding: EdgeInsets.only(left: 60),
                child: ExcerptCommentItem(
                  bean,
                  bean.comment,
                  onCommentDeleted: onCommentDeleted,
                ))
          ],
        ));
  }
}
