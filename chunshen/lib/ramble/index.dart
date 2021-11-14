import 'package:chunshen/base/widget/loading/index.dart';
import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/ramble/ramble_content.dart';
import 'package:flutter/material.dart';

class RamblePage extends StatefulWidget {
  @override
  _RambleState createState() => _RambleState();
}

class _RambleState extends State<RamblePage>
    with AutomaticKeepAliveClientMixin {
  List<Widget> pages = [];
  List<ExcerptBean> excerptData = [];
  Map<String, ExcerptBean> excerptMap = {};
  bool loading = false;
  PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1,
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.position.pixels ==
          _pageController.position.maxScrollExtent) {
        getRambleData(true);
      }
    });
    getRambleData();
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
                : Container())
      ],
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
