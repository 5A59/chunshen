import 'package:chunshen/model/excerpt.dart';
import 'package:flutter/material.dart';
import 'package:chunshen/model/index.dart';

class ExcerptPage extends StatefulWidget {
  @override
  ExcerptState createState() => ExcerptState();
}

class ExcerptState extends State<ExcerptPage> {
  List<ExcerptBean> list = List.empty(growable: true);
  int page = 0;

  @override
  void initState() {
    super.initState();
    getNextPageData();
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
    return ListView.builder(
      itemBuilder: (context, i) {
        if (i == list.length && list.length > 0) {
          getNextPageData();
          return Text('loading...');
        } else {}
        return Text(list[i].excerptContent?.content ?? 'null');
      },
      itemCount: list.length + 1,
    );
  }
}
