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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 100),
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
          SizedBox(
            height: 30,
          ),
          Text(widget.bean?.excerptContent?.content ?? '')
        ],
      ),
    );
  }
}
