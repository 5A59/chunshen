import 'package:chunshen/base/widget/loading/index.dart';
import 'package:chunshen/main/index.dart';
import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/tag.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/tag/index.dart';
import 'package:flutter/material.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/excerpt/excerpt_item.dart';

class ExcerptPage extends StatefulWidget implements IOperationListener {
  final _ExcerptState state = _ExcerptState();

  @override
  _ExcerptState createState() => state;

  @override
  onExcerptUploadFinished() {
    state.forceRefresh();
  }
}

class _ExcerptState extends State<ExcerptPage>
    with AutomaticKeepAliveClientMixin {
  List<ExcerptBean> list = [];
  List<TagBean> tagList = [];
  int page = 0;
  bool finish = false;
  Set<String> tags = Set();
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();
  GlobalKey<TagWidgetState> _tagKey = GlobalKey();
  bool refreshFlag = false;

  @override
  void initState() {
    super.initState();
    getNextPageData();
  }

  void getTagList() async {
    _tagKey.currentState?.refresh();
  }

  void getNextPageData() async {
    if (!finish) {
      ExcerptModel.getExcerptListBean(page, tags).then((value) {
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

  onTagSelected(Set<String> tags, List<TagBean> list) {
    this.tags.clear();
    this.tags.addAll(tags);
    forceRefresh();
  }

  forceRefresh() {
    _refreshKey.currentState?.show();
  }

  Future<void> refresh() async {
    getTagList();
    ExcerptListBean bean = await ExcerptModel.getExcerptListBean(0, tags);
    setState(() {
      list = [...bean.content];
      finish = false;
      page = 1;
    });
  }

  onExcerptDelete(int i) {
    setState(() {
      list.removeAt(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(children: [
      Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 40,
            ),
            Expanded(
                child: RefreshIndicator(
                    key: _refreshKey,
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
                          return ExcerptItem(
                            list[i],
                            onExcerptDelete: () {
                              onExcerptDelete(i);
                            },
                          );
                        } else {
                          return Container();
                        }
                      },
                      itemCount: list.length + 1,
                    ))),
          ])),
      TagWidget(onTagSelected, key: _tagKey),
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}
