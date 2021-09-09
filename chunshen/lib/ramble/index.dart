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
  bool loading = false;

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
      Future.delayed(Duration(milliseconds: 5000)).then((value) {
        List<ExcerptBean> tmp = RambleModel.getRambleData();
        setState(() {
          loading = false;
          excerptData.addAll(tmp);
          pages = [...pages, ...tmp.map((e) => RambleContent(e)).toList()];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Row(
      children: [
        Expanded(
            child: PageView(
          scrollDirection: Axis.vertical,
          controller: PageController(
            initialPage: 0,
            viewportFraction: 1,
            keepPage: true,
          ),
          physics: BouncingScrollPhysics(),
          onPageChanged: (index) {
            getRambleData(index);
          },
          children: this.pages,
        )),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
