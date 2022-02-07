import 'package:chunshen/base/widget/image/big_image.dart';
import 'package:chunshen/base/widget/image/cs_image.dart';
import 'package:chunshen/excerpt/more_menu.dart';
import 'package:chunshen/main/bus.dart';
import 'package:chunshen/main/index.dart';
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
            margin: EdgeInsets.only(bottom: 10),
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
  final IOperationListener? operationListener;

  ExcerptContentItem(this.bean, this.onCommentAdded, this.onExcerptDeleted,
      {this.operationListener});

  @override
  State<StatefulWidget> createState() {
    return _ExcerptContentItemState(this.bean);
  }
}

class _ExcerptContentItemState extends State<ExcerptContentItem>
    implements IMenuListener {
  ExcerptBean? bean;
  final InputBorder border = InputBorder.none;
  bool showCommentInput = false;
  String? comment = '';
  late MoreMenu moreMenu;

  _ExcerptContentItemState(this.bean);

  @override
  void initState() {
    moreMenu = MoreMenu(this.bean, context, this);
    super.initState();
  }

  PopupMenuItem<String> getPopItem(String text, String value) {
    return PopupMenuItem<String>(
      child: Text(text),
      value: value,
    );
  }

  handleShare() {}

  Widget buildMoreMenu() {
    return moreMenu.buildMoreMenu();
  }

  triggerCommentInput(show) {
    setState(() {
      showCommentInput = show;
    });
  }

  refreshExcerpt(ExcerptUploadBean uploadBean) {
    setState(() {
      widget.bean?.excerptContent?.content = uploadBean.content;
      widget.bean?.tag?.id = uploadBean.tagId;
      widget.bean?.image = uploadBean.image;
      if (!isEmpty(uploadBean.id)) {
        widget.bean?.id = uploadBean.id;
      }
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
        await CommentModel.uploadNewComment(this.bean?.id, comment);
    if (commentBean != null) {
      toast('提交成功');
      triggerCommentInput(false);
      widget.onCommentAdded?.call(commentBean);
    } else {
      toast('提交失败，请稍后重试～');
    }
  }

  Widget buildCommentInput() {
    return moreMenu.buildCommentInput();
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

  _buildHead(TagBean? tag) {
    if (isEmpty(tag?.head)) {
      return ClipOval(
          child: SizedBox(
        width: 50,
        height: 50,
        child: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Image(image: AssetImage('assets/images/icon_no_bg.png')),
          color: Color(CSColor.gray),
        ),
      ));
    }
    return ClipOval(child: CSImage.buildImage(tag?.head, 50, 50));
  }

  @override
  Widget build(BuildContext context) {
    TagBean? tag = this.bean?.tag;
    ExcerptContentBean? bean = this.bean?.excerptContent;
    return bean != null
        ? Column(
            children: [
              Row(
                children: [
                  _buildHead(tag),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    tag?.content ?? '',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(CSColor.lightBlack),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              GestureDetector(
                onLongPress: () {
                  copyToClipboard(bean.content);
                },
                child: Text(bean.content ?? '',
                    style: TextStyle(fontSize: 16, height: 2)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    formatTime(bean.time) ?? '',
                    style: TextStyle(color: Color(CSColor.gray2)),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  buildMoreMenu()
                ],
              ),
              if (hasImage(this.bean)) SizedBox(height: 15),
              if (hasImage(this.bean)) buildImage(this.bean?.image ?? []),
              if (hasImage(this.bean)) SizedBox(height: 15),
              showCommentInput ? buildCommentInput() : Container()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          )
        : Spacer();
  }

  @override
  onDeleteSuccess() {
    widget.onExcerptDeleted?.call();
  }

  @override
  onEdit(ExcerptUploadBean? bean) {
    if (bean != null) {
      // refreshExcerpt(bean);
      widget.operationListener?.onExcerptUploadFinished();
      updateExcerpt(widget.bean);
    }
  }

  @override
  onComment(bool show) {
    triggerCommentInput(show);
  }

  @override
  onCommentChanged(String content) {
    comment = content;
  }

  @override
  onCommentUpload() {
    uploadComment();
    updateExcerpt(widget.bean);
  }
}

class ExcerptItem extends StatefulWidget {
  final ExcerptBean bean;
  final Function? onExcerptDelete;
  final IOperationListener? operationListener;
  Key? key;

  ExcerptItem(this.bean,
      {this.onExcerptDelete, this.key, this.operationListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ExcerptItemState(this.bean);
  }
}

class _ExcerptItemState extends State<ExcerptItem> {
  final ExcerptBean bean;

  _ExcerptItemState(this.bean);

  onCommentAdded(ExcerptCommentBean comment) {
    setState(() {
      this.bean.comment.add(comment);
    });
  }

  onCommentDeleted(ExcerptCommentBean comment) {
    setState(() {
      this.bean.comment.remove(comment);
    });
  }

  onExcerptDeleted() {
    widget.onExcerptDelete?.call();
  }

  @override
  Widget build(BuildContext context) {
    ExcerptBean bean = this.bean;
    return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: ExcerptContentItem(
                    bean,
                    onCommentAdded,
                    onExcerptDeleted,
                    operationListener: widget.operationListener,
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Container(
                // padding: EdgeInsets.only(left: 60),
                child: ExcerptCommentItem(
              bean,
              bean.comment,
              onCommentDeleted: onCommentDeleted,
            )),
            Divider(
              height: 10,
              color: Color(CSColor.gray2),
            ),
          ],
        ));
  }
}
