import 'package:chunshen/config.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';

Widget buildEmptyView(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
          child: ImageIcon(
        AssetImage('assets/images/icon_no_bg.png'),
        size: 50,
        color: Color(CSColor.gray5),
      )),
      SizedBox(
        height: 30,
      ),
      Text(
        '当前没有书摘，快去添加吧～',
        style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(CSColor.gray5),
            fontSize: 15),
      ),
      SizedBox(
        height: 30,
      ),
      GestureDetector(
        onTap: () {
          openPage(context, PAGE_GUIDE);
        },
        child: Text(
          '查看使用指南',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(CSColor.gray5),
              fontSize: 15),
        ),
      )
    ],
  );
}
