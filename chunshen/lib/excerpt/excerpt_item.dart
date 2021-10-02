import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/model/tag.dart';
import 'package:chunshen/net/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:chunshen/style/index.dart';

class ExcerptCommentItem extends StatelessWidget {
  final List<ExcerptCommentBean>? comment;

  ExcerptCommentItem(this.comment);

  @override
  Widget build(BuildContext context) {
    return (comment?.length ?? 0) > 0
        ? Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ListView.builder(
              shrinkWrap: true,
              physics: new NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (i > 0)
                          Divider(
                            height: 15,
                            color: Color(CSColor.gray1),
                          ),
                        Text(comment?[i].content ?? ''),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              formatTime(comment?[i].time) ?? '',
                              style: TextStyle(color: Color(CSColor.gray2)),
                            )
                          ],
                        )
                      ],
                    ));
              },
              itemCount: comment?.length ?? 0,
            ),
            decoration: BoxDecoration(color: Color(CSColor.gray)))
        : Container();
  }
}

class ExcerptContentItem extends StatefulWidget {
  final ExcerptBean? bean;
  final Function? onCommentAdded;

  ExcerptContentItem(this.bean, this.onCommentAdded);

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
      case 'comment':
        triggerCommentInput(true);
        break;
      case 'edit':
        break;
      case 'delete':
        break;
      default:
    }
  }

  triggerCommentInput(show) {
    setState(() {
      showCommentInput = show;
    });
  }

  uploadComment() async {
    if (isEmpty(comment)) {
      triggerCommentInput(false);
      return;
    }
    CSResponse response =
        await CommentModel.uploadNewComment(widget.bean?.id, comment);
    if (response.status == 0) {
      toast('提交成功');
      triggerCommentInput(false);
      widget.onCommentAdded?.call(ExcerptCommentBean.create(
          comment, DateTime.now().microsecondsSinceEpoch));
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
              TextButton(onPressed: uploadComment, child: Text('提交'))
            ],
          )
        ],
      ),
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
              Text(bean.content ?? ''),
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
              showCommentInput ? buildCommentInput() : Container()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          )
        : Spacer();
  }
}

class ExcerptItem extends StatefulWidget {
  final ExcerptBean bean;
  ExcerptItem(this.bean);

  @override
  State<StatefulWidget> createState() {
    return ExcerptItemState();
  }
}

class ExcerptItemState extends State<ExcerptItem> {
  // final ExcerptBean bean;

  // ExcerptItemState(this.bean);

  onCommentAdded(ExcerptCommentBean comment) {
    setState(() {
      widget.bean.comment.add(comment);
    });
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
                Image.network(bean.tag?.head ?? '', width: 50, height: 80),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: ExcerptContentItem(bean, onCommentAdded),
                )
              ],
            ),
            SizedBox(height: 15),
            Container(
                padding: EdgeInsets.only(left: 60),
                child: ExcerptCommentItem(bean.comment))
          ],
        ));
  }
}
