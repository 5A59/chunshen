import 'package:flutter/material.dart';

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
          TabBar(tabs: [
            Tab(icon: Icon(Icons.backpack_rounded)),
            Tab(icon: Icon(Icons.backpack_rounded)),
          ]),
          TabBarView(children: [
            Tab(icon: Icon(Icons.backpack_rounded)),
            Tab(icon: Icon(Icons.backpack_rounded)),
          ])
        ],
      ),
    );
  }
}
