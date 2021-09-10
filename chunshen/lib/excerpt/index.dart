import 'package:chunshen/base/widget/loading/index.dart';
import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/tag.dart';
import 'package:chunshen/style/index.dart';
import 'package:flutter/material.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/excerpt/excerpt_item.dart';
import 'package:chunshen/excerpt/tag.dart';

class ExcerptPage extends StatefulWidget {
  @override
  _ExcerptState createState() => _ExcerptState();
}

class _ExcerptState extends State<ExcerptPage>
    with AutomaticKeepAliveClientMixin {
  List<ExcerptBean> list = [];
  List<TagBean> tagList = [];
  int page = 0;
  bool finish = false;

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
    if (!finish) {
      ExcerptModel.getExcerptListBean(page).then((value) {
        setState(() {
          if (value.content.length > 0) {
            list.addAll(value.content);
            page++;
          } else {
            finish = true;
          }
        });
      });
    }
  }

  Future<void> refresh() async {
    ExcerptListBean bean = await ExcerptModel.getExcerptListBean(0);
    if (bean.content.length > 0) {
      setState(() {
        list = [...bean.content];
        finish = false;
        page = 1;
      });
    }
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
              child: RefreshIndicator(
                  color: Color(CSColor.black),
                  onRefresh: refresh,
                  child: ListView.builder(
                    itemBuilder: (context, i) {
                      if (i == list.length && list.length > 0 && !finish) {
                        getNextPageData();
                        return Container(
                            alignment: Alignment.center,
                            height: 50,
                            child: SizedBox(
                                width: 50,
                                height: 50,
                                child: BallBounceLoading()));
                      } else if (i < list.length) {
                        // return Text(list[i].excerptContent?.content ?? 'null');
                        return ExcerptItem(list[i]);
                      } else {
                        return Container();
                      }
                    },
                    itemCount: list.length + 1,
                  ))),
        ]));
  }

  @override
  bool get wantKeepAlive => true;
}
