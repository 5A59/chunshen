import 'package:chunshen/style/index.dart';
import 'package:flutter/material.dart';
import 'package:chunshen/excerpt/index.dart';
import 'package:chunshen/ramble/index.dart';

class MainPage extends StatefulWidget {
  @override
  MainState createState() => MainState();
}

class MainState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
          Expanded(child: TabBarView(children: [ExcerptPage(), RamblePage()]))
        ],
      ),
    );
  }
}
