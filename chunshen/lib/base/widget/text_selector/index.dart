import 'package:chunshen/style/index.dart';
import 'package:flutter/material.dart';

class TextSelectorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TextSelectorState();
  }
}

class _TextSelectorState extends State<TextSelectorPage> {
  String text = '测试大家都叫阿克苏多久啊多久啊大电视剧啊看手机打开手机打开手机打开手机的';

  List<Widget> getWidgetByText(String text) {
    List<Widget> list = [];
    for (int i = 0; i < text.length; i++) {
      list.add(_SignleText(text[i]));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Listener(
          child: Container(
              padding: EdgeInsets.all(10),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: getWidgetByText(text),
              ))),
    ));
  }
}

class _SignleText extends StatefulWidget {
  String text;
  _SignleText(this.text);

  @override
  State<StatefulWidget> createState() {
    return _SignleState();
  }
}

class _SignleState extends State<_SignleText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          border: Border.all(color: Color(CSColor.gray2), width: 0.5),
          borderRadius: BorderRadius.circular(3)),
      child: Text(widget.text),
    );
  }
}
