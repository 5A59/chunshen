import 'package:chunshen/model/tag.dart';
import 'package:chunshen/style/index.dart';
import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  List<TagBean> list;

  TagWidget(this.list);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        height: 30,
        child: Row(children: [
          Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              return Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Color(CSColor.gray4), width: 0.5),
                      borderRadius: BorderRadius.circular(3)),
                  child: Text(
                    list[i].content ?? '',
                    style: TextStyle(color: Color(CSColor.gray4)),
                  ));
            },
            itemCount: list.length,
          ))
        ]));
  }
}
