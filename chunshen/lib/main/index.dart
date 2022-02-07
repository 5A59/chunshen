import 'package:chunshen/bar/index.dart';
import 'package:chunshen/global/index.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/net/index.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:chunshen/excerpt/index.dart';
import 'package:chunshen/ramble/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _login();
    initNet().then((value) {
      setState(() {
        inited = true;
      });
    });
    super.initState();
  }

  void _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    if (username == null || password == null) {
      return;
    }
    String md5Pwd = generateMd5(password);
    CSResponse response = await UserModel.login(username, md5Pwd);
    if (CSResponse.success(response)) {
      Global.username = username;
      Global.onLogin();
    }
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
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text('书摘',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text('漫步',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  unselectedLabelColor: Color(CSColor.gray3),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: TabBarView(children: [excerptPage, ramblePage])),
                Divider(
                  height: 1,
                ),
                OperationBar(
                  [excerptPage, ramblePage],
                )
              ],
            ),
          )
        : Container();
  }
}
