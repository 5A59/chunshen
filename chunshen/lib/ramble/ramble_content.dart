import 'package:chunshen/excerpt/excerpt_item.dart';
import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/style/index.dart';
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

class RambleContentState extends State<RambleContent> {
  SizedBox space = SizedBox(
    height: 30,
  );
  Drag? drag;
  DragStartDetails? dragStartDetails;

  @override
  void initState() {
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
                    widget.bean?.excerptContent?.tag ?? '',
                    style: TextStyle(
                        color: Color(CSColor.blue),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  space,
                  Text(bean?.excerptContent?.content ?? ''),
                  space,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        bean?.excerptContent?.time ?? '',
                        style: TextStyle(color: Color(CSColor.gray2)),
                      )
                    ],
                  ),
                  space,
                  ExcerptCommentItem(bean?.comment)
                ],
              ))),
    );
  }
}
