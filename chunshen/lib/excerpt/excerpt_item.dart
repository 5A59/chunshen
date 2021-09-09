import 'package:chunshen/model/excerpt.dart';
import 'package:flutter/material.dart';
import 'package:chunshen/style/index.dart';

class ExcerptCommentItem extends StatelessWidget {
  List<ExcerptCommentBean> comment = [];

  ExcerptCommentItem(this.comment);

  @override
  Widget build(BuildContext context) {
    return comment.length > 0
        ? Container(
            margin: EdgeInsets.only(left: 60),
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
                        Text(comment[i].content ?? ''),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              comment[i].time ?? '',
                              style: TextStyle(color: Color(CSColor.gray2)),
                            )
                          ],
                        )
                      ],
                    ));
              },
              itemCount: comment.length,
            ),
            decoration: BoxDecoration(color: Color(CSColor.gray)))
        : Container();
  }
}

class ExcerptContentItem extends StatelessWidget {
  ExcerptContentBean? bean;

  ExcerptContentItem(this.bean);

  @override
  Widget build(BuildContext context) {
    return this.bean != null
        ? Column(
            children: [
              Text(
                this.bean?.tag ?? '',
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
                    this.bean?.time ?? '',
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
  ExcerptBean bean;

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
                Image.network(bean.excerptContent?.head ?? '',
                    width: 50, height: 80),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: ExcerptContentItem(bean.excerptContent),
                )
              ],
            ),
            SizedBox(height: 15),
            ExcerptCommentItem(bean.comment)
          ],
        ));
  }
}
