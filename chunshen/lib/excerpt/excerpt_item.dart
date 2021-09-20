import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/tag.dart';
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

class ExcerptContentItem extends StatelessWidget {
  final TagBean? tag;
  final ExcerptContentBean? bean;

  ExcerptContentItem(this.tag, this.bean);

  @override
  Widget build(BuildContext context) {
    return this.bean != null
        ? Column(
            children: [
              Text(
                this.tag?.content ?? '',
                style: TextStyle(
                    fontSize: 18,
                    color: Color(CSColor.blue),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(this.bean?.content ?? ''),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    formatTime(this.bean?.time) ?? '',
                    style: TextStyle(color: Color(CSColor.gray2)),
                  )
                ],
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          )
        : Spacer();
  }
}

class ExcerptItem extends StatelessWidget {
  final ExcerptBean bean;

  ExcerptItem(this.bean);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(bean.tag?.head ?? '',
                    width: 50, height: 80),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: ExcerptContentItem(bean.tag, bean.excerptContent),
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
