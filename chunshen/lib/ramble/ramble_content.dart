import 'package:chunshen/excerpt/excerpt_item.dart';
import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/style/index.dart';
import 'package:flutter/material.dart';

class RambleContent extends StatefulWidget {
  final ExcerptBean? bean;
  RambleContent(this.bean);

  @override
  State<StatefulWidget> createState() {
    return RambleContentState();
  }
}

class RambleContentState extends State<RambleContent> {
  SizedBox space = SizedBox(
    height: 30,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ExcerptBean? bean = widget.bean;
    return Container(
      padding: EdgeInsets.only(bottom: 100, left: 20, right: 20),
      child: SingleChildScrollView(
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
      )),
    );
  }
}
