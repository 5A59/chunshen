import 'package:chunshen/base/widget/empty/index.dart';
import 'package:chunshen/base/widget/loading/index.dart';
import 'package:chunshen/main/bus.dart';
import 'package:chunshen/main/index.dart';
import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/tag.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/tag/index.dart';
import 'package:flutter/material.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/excerpt/excerpt_item.dart';

class ExcerptPage extends StatefulWidget with IOperationListener {
  final _ExcerptState state = _ExcerptState();

  @override
  _ExcerptState createState() => state;

  @override
  onExcerptUploadFinished() {
    state.forceRefresh();
  }

  @override
  onTagChanged() {
    state.getTagList();
  }
}

class _ExcerptState extends State<ExcerptPage>
    with AutomaticKeepAliveClientMixin, IExcerptOperationListener {
  List<ExcerptBean> list = [];
  List<TagBean> tagList = [];
  int page = 0;
  bool finish = false;
  Set<String> tags = Set();
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();
  GlobalKey<TagWidgetState> _tagKey = GlobalKey();
  bool refreshFlag = false;

  _ExcerptState() {
    addExcerptOperationListener(this);
  }

  @override
  onExcerptUpdate(ExcerptBean? bean) {
    forceRefresh();
    // list.forEach((element) {
    //   setState(() {
    //     if (element.id == bean.id) {
    //       element.comment = bean.comment;
    //       element.excerptContent = bean.excerptContent;
    //       element.tag = bean.tag;
    //       element.tagId = bean.tagId;
    //       element.image = bean.image;
    //     }
    //   });
    // });
  }

  @override
  onExcerptAdd(ExcerptBean? bean) {
    forceRefresh();
  }

  @override
  onExcerptDelete(ExcerptBean? bean) {
    forceRefresh();
  }

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

  _onExcerptDelete(int i) {
    ExcerptBean bean = list[i];
    setState(() {
      list.removeAt(i);
    });
    deleteExcerpt(bean);
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
              height: 60,
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
                              _onExcerptDelete(i);
                            },
                            key: UniqueKey(),
                            operationListener: widget,
                          );
                        } else {
                          return Container();
                        }
                      },
                      itemCount: list.length + 1,
                    ))),
            if (list.length <= 0)
              Expanded(
                  flex: 100,
                  child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(bottom: 100),
                      child: buildEmptyView(context)))
          ])),
      TagWidget(
        onTagSelected,
        dismissWhenNoTag: true,
        key: _tagKey,
        defaultText: '   暂无书籍，点击右下角“管理书籍”添加',
      ),
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}
