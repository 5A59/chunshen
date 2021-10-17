import 'package:chunshen/bar/index.dart';
import 'package:chunshen/net/index.dart';
import 'package:chunshen/style/index.dart';
import 'package:flutter/material.dart';
import 'package:chunshen/excerpt/index.dart';
import 'package:chunshen/ramble/index.dart';

abstract class IOperationListener {
  onExcerptUploadFinished() {}
  onTagChanged() {}
}

class MainPage extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<MainPage> {
  ExcerptPage excerptPage = ExcerptPage();
  RamblePage ramblePage = RamblePage();
  bool inited = false;

  @override
  void initState() {
    initNet().then((value) {
      setState(() {
        inited = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return inited
        ? DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(text: '书摘'),
                    Tab(text: '漫步'),
                  ],
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  unselectedLabelColor: Color(CSColor.gray3),
                ),
                Expanded(
                    child: TabBarView(children: [excerptPage, ramblePage])),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                OperationBar(
                  excerptPage,
                )
              ],
            ),
          )
        : Container();
  }
}
