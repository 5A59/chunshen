import 'package:chunshen/style/index.dart';
import 'package:flutter/material.dart';

class OperationBar extends StatelessWidget {
  List<Widget> getIconWithSpace(IconData iconData) {
    return [
      Icon(
        iconData,
        size: 35,
      ),
      SizedBox(width: 20)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        color: Color(CSColor.white),
        child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                ...getIconWithSpace(Icons.photo_camera),
                ...getIconWithSpace(Icons.keyboard),
                ...getIconWithSpace(Icons.publish),
                Expanded(child: SizedBox()),
                Icon(
                  Icons.tune,
                  size: 35,
                )
              ],
            )));
  }
}
