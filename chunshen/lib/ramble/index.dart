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
  bool loading = false;
  PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1,
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
    getRambleData();
  }

  void getRambleData([int curPage = -1]) {
    if (excerptData.isEmpty || curPage >= excerptData.length - 1) {
      setState(() {
        loading = true;
      });
      RambleModel.getRambleData().then((value) {
        setState(() {
          loading = false;
          excerptData.addAll(value);
          pages = [...pages, ...value.map((e) => RambleContent(e)).toList()];
        });
        if (curPage != -1 && curPage < excerptData.length - 1) {
          _pageController.nextPage(
              duration: Duration(milliseconds: 400), curve: Curves.easeOut);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(
            child: PageView(
          scrollDirection: Axis.vertical,
          controller: _pageController,
          physics: BouncingScrollPhysics(),
          onPageChanged: (index) {
            getRambleData(index);
          },
          children: this.pages,
        )),
        loading
            ? Container(
                alignment: Alignment.center,
                height: 50,
                child:
                    SizedBox(width: 50, height: 50, child: BallBounceLoading()))
            : Container()
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
