import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/ramble/ramble_content.dart';
import 'package:flutter/material.dart';

class RamblePage extends StatefulWidget {
  @override
  RambleState createState() => RambleState();
}

class RambleState extends State<RamblePage> with AutomaticKeepAliveClientMixin {
  List<Widget> pages = [];
  List<ExcerptBean> excerptData = [];

  @override
  void initState() {
    super.initState();
    getRambleData();
  }

  void getRambleData({int curPage = -1}) {
    if (excerptData.isEmpty || curPage >= excerptData.length) {
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        List<ExcerptBean> tmp = RambleModel.getRambleData();
        excerptData.addAll(tmp);
        setState(() {
          tmp.forEach((element) {
            pages.add(RambleContent(element));
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageView(
      scrollDirection: Axis.vertical,
      controller: PageController(
        initialPage: 0,
        viewportFraction: 1,
        keepPage: true,
      ),
      physics: BouncingScrollPhysics(),
      onPageChanged: (index) {
        //   getRambleData();
      },
      children: this.pages,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
