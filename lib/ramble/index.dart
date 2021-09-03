import 'package:flutter/material.dart';

class RamblePage extends StatefulWidget {
  @override
  RambleState createState() => RambleState();
}

class RambleState extends State<RamblePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Text('ramble');
  }

  @override
  bool get wantKeepAlive => true;
}