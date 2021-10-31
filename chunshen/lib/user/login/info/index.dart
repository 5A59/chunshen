import 'package:chunshen/global/index.dart';
import 'package:chunshen/style/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserInfoPageState();
  }
}

class _UserInfoPageState extends State<UserInfoPage> {
  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', '');
    await prefs.setString('password', '');
  }

  Widget _buildItem(String tag, String content) {
    return Row(
      children: [Text(tag), Text(content)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(CSColor.white),
            title: Text('用户信息')),
        body: SingleChildScrollView(
            child: Container(
          child: Column(
            children: [
              _buildItem('用户名', Global.username ?? ''),
              GestureDetector(
                onTap: _logout,
                child: Container(
                  child: Text('退出登录'),
                ),
              )
            ],
          ),
        )));
  }
}
