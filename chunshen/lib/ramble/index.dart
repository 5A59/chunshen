import 'package:chunshen/base/widget/empty/index.dart';
import 'package:chunshen/base/widget/loading/index.dart';
import 'package:chunshen/main/bus.dart';
import 'package:chunshen/main/index.dart';
import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/ramble/ramble_content.dart';
import 'package:flutter/material.dart';

class RamblePage extends StatefulWidget with IOperationListener {
  _RambleState state = _RambleState();
  bool stateInited = false;

  @override
  _RambleState createState() => state;

  @override
  onExcerptUploadFinished() {
    if (stateInited) {
      state.getRambleData();
    }
  }
}

class _RambleState extends State<RamblePage>
    with AutomaticKeepAliveClientMixin, IExcerptOperationListener {
  List<Widget> pages = [];
  List<ExcerptBean> excerptData = [];
  Map<String, ExcerptBean> excerptMap = {};
  bool loading = false;
  PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1,
    keepPage: true,
  );

  _RambleState() {
    addExcerptOperationListener(this);
  }

  @override
  onExcerptDelete(ExcerptBean? bean) {
    for (int i = 0; i < excerptData.length; i++) {
      if (bean?.id == excerptData[i].id) {
        excerptData.removeAt(i);
        excerptMap.remove(bean?.id);
        pages.removeAt(i);
      }
    }
    setState(() {
      pages = [...pages];
    });
  }

  @override
  onExcerptUpdate(ExcerptBean? bean) {
    if (bean == null) {
      return;
    }
    for (int i = 0; i < excerptData.length; i++) {
      if (bean.id == excerptData[i].id) {
        excerptData[i] = bean;
        excerptMap[bean.id ?? ''] = bean;
        pages[i] = RambleContent(
          bean,
          parentController: _pageController,
        );
      }
    }
    setState(() {
      pages = [...pages];
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.position.pixels >
          _pageController.position.maxScrollExtent) {
        getRambleData(true);
      }
    });
    getRambleData();
    widget.stateInited = true;
  }

  ExcerptBean? getExcerpt(ExcerptBean bean) {
    if (excerptMap.containsKey(bean.id)) {
      return excerptMap[bean.id];
    } else {
      excerptMap[bean.id ?? ''] = bean;
    }
    return bean;
  }

  void getRambleData([bool autoNext = false]) {
    if (loading) {
      return;
    }
    setState(() {
      loading = true;
    });
    RambleModel.getRambleData().then((value) {
      setState(() {
        loading = false;
        excerptData.addAll(value);
        pages = [
          ...pages,
          ...value.map((e) {
            return RambleContent(
              getExcerpt(e),
              parentController: _pageController,
            );
          }).toList()
        ];
      });
      if (autoNext) {
        _pageController.nextPage(
            duration: Duration(milliseconds: 400), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        child: Stack(
      children: [
        PageView(
          scrollDirection: Axis.vertical,
          controller: _pageController,
          physics: BouncingScrollPhysics(),
          onPageChanged: (index) {
            // getRambleData(index);
          },
          children: this.pages,
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: loading
                ? Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: SizedBox(
                        width: 50, height: 50, child: BallBounceLoading()))
                : Container()),
        if (pages.length <= 0)
          Container(
            alignment: Alignment.center,
            child: buildEmptyView(context),
          )
      ],
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
