import 'package:chunshen/base/widget/image/big_image.dart';
import 'package:chunshen/base/widget/image/cs_image.dart';
import 'package:chunshen/excerpt/excerpt_item.dart';
import 'package:chunshen/excerpt/more_menu.dart';
import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RambleContent extends StatefulWidget {
  final ExcerptBean? bean;
  final PageController? parentController;
  RambleContent(this.bean, {this.parentController});

  @override
  State<StatefulWidget> createState() {
    return RambleContentState();
  }
}

class RambleContentState extends State<RambleContent> implements IMenuListener {
  SizedBox space = SizedBox(
    height: 30,
  );
  Drag? drag;
  DragStartDetails? dragStartDetails;
  late MoreMenu moreMenu;
  bool showCommentInput = false;
  String? comment;

  @override
  void initState() {
    moreMenu = new MoreMenu(widget.bean, context, this);
    super.initState();
  }

  bool onNotification(Notification notification) {
    if (notification is ScrollStartNotification) {
      dragStartDetails = notification.dragDetails;
    }
    if (notification is OverscrollNotification) {
      if (dragStartDetails != null) {
        drag = widget.parentController?.position.drag(dragStartDetails!, () {});
        if (notification.dragDetails != null) {
          drag?.update(notification.dragDetails!);
        }
      }
    }
    if (notification is ScrollEndNotification) {
      if (notification.dragDetails != null) {
        drag?.end(notification.dragDetails!);
      }
    }
    return false;
  }

  bool hasImage(ExcerptBean? bean) {
    return bean?.image != null && (bean?.image!.length ?? 0) > 0;
  }

  Widget buildMoreMenu() {
    return moreMenu.buildMoreMenu();
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
    ExcerptBean? bean = widget.bean;
    return Container(
      padding: EdgeInsets.only(bottom: 50, left: 20, right: 20, top: 50),
      child: NotificationListener(
          onNotification: onNotification,
          child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.bean?.tag?.content ?? '',
                    style: TextStyle(
                        color: Color(CSColor.lightBlack),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  space,
                  Text(
                    bean?.excerptContent?.content ?? '',
                    style: TextStyle(fontSize: 16, height: 1.7),
                  ),
                  space,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        formatTime(bean?.excerptContent?.time) ?? '',
                        style: TextStyle(color: Color(CSColor.gray2)),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      moreMenu.buildMoreMenu(),
                    ],
                  ),
                  showCommentInput ? moreMenu.buildCommentInput() : Container(),
                  if (hasImage(bean)) buildImage(bean?.image ?? []),
                  space,
                  ExcerptCommentItem(bean, bean?.comment)
                ],
              ))),
    );
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
      if (!isEmpty(uploadBean.tagName)) {
        widget.bean?.tag?.content = uploadBean.tagName;
      }
      if (!isEmpty(uploadBean.tagImage)) {
        widget.bean?.tag?.head = uploadBean.tagImage;
      }
    });
  }

  @override
  onComment(bool show) {
    triggerCommentInput(show);
  }

  @override
  onDeleteSuccess() {}

  @override
  onEdit(ExcerptUploadBean? bean) {
    if (bean != null) {
      refreshExcerpt(bean);
    }
  }

  @override
  onCommentChanged(String content) {
    comment = content;
  }

  @override
  onCommentUpload() async {
    if (isEmpty(comment)) {
      triggerCommentInput(false);
      return;
    }
    ExcerptCommentBean? commentBean =
        await CommentModel.uploadNewComment(widget.bean?.id, comment);
    if (commentBean != null) {
      toast('提交成功');
      triggerCommentInput(false);
      setState(() {
        widget.bean?.comment.add(commentBean);
      });
    } else {
      toast('提交失败，请稍后重试～');
    }
  }
}
