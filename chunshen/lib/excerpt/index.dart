import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/tag.dart';
import 'package:flutter/material.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/excerpt/excerpt_item.dart';
import 'package:chunshen/excerpt/tag.dart';

class ExcerptPage extends StatefulWidget {
  @override
  ExcerptState createState() => ExcerptState();
}

class ExcerptState extends State<ExcerptPage>
    with AutomaticKeepAliveClientMixin {
  List<ExcerptBean> list = [];
  List<TagBean> tagList = [];
  int page = 0;

  @override
  void initState() {
    super.initState();
    getTagList();
    getNextPageData();
  }

  void getTagList() async {
    Future.delayed(Duration(milliseconds: 500)).then((value) => {
          setState(() {
            TagListBean listBean = TagModel.getTagListBean();
            tagList.addAll(listBean.list);
          })
        });
  }

  void getNextPageData() async {
    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      setState(() {
        ExcerptListBean tmp = ExcerptModel.getExcerptListBean(page);
        list.addAll(tmp.content);
      });
      page++;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TagWidget(tagList),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, i) {
              if (i == list.length && list.length > 0) {
                getNextPageData();
                return Text('...');
              } else if (i < list.length) {
                // return Text(list[i].excerptContent?.content ?? 'null');
                return ExcerptItem(list[i]);
              } else {
                return Text('list empty');
              }
            },
            itemCount: list.length + 1,
          )),
        ]));
  }

  @override
  bool get wantKeepAlive => true;
}
