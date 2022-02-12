import 'dart:io';

import 'package:chunshen/style/index.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GuidePage extends StatefulWidget {
  GuidePage();

  @override
  State<StatefulWidget> createState() {
    return _GuideState();
  }
}

class _GuideState extends State<GuidePage> {
  PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1,
    keepPage: true,
  );
  List<String> pages = ['assets/images/icon.png', 'assets/images/icon.png'];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < pages.length; i++) {
      list.add(i == selectedIndex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return Container(
      height: 10,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: Color(CSColor.yellow).withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.circle,
          color: isActive ? Color(CSColor.yellow) : Color(CSColor.gray2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(CSColor.white),
          title: Text('使用指南'),
        ),
        body: Container(
          child: WebView(
            initialUrl: 'https://shimo.im/docs/PYwVXcgYDDgwCYCp/',
          ),
        ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         elevation: 0,
  //         backgroundColor: Color(CSColor.white),
  //         title: Text('使用指南'),
  //       ),
  //       body: Container(
  //           padding: EdgeInsets.all(10),
  //           alignment: Alignment.center,
  //           child: Column(
  //             children: [
  //               Expanded(
  //                   child: PageView(
  //                 controller: _pageController,
  //                 physics: BouncingScrollPhysics(),
  //                 onPageChanged: (index) {
  //                   setState(() {
  //                     selectedIndex = index;
  //                   });
  //                 },
  //                 children: [
  //                   ...pages.map((e) {
  //                     return Image.asset(e);
  //                   })
  //                 ],
  //               )),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [..._buildPageIndicator()],
  //               )
  //             ],
  //           )));
  // }
}
