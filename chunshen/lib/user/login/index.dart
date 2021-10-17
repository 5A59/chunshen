import 'package:chunshen/model/index.dart';
import 'package:chunshen/net/index.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  String? username;
  String? password;

  void _login() async {
    if (username == null || password == null) {
      toast('请输入账号和密码');
      return;
    }
    CSResponse response = await UserModel.login(username, password);
    if (CSResponse.success(response)) {
      toast('登录成功');
    } else {
      if (isEmpty(response.msg)) {
        toast(response.msg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(CSColor.white),
            title: Text('登录')),
        body: SingleChildScrollView(
          child: Container(
              child: Column(
            children: [
              TextField(
                onChanged: (String content) {
                  username = content;
                },
                style: TextStyle(
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                    hintText: '输入邮箱'),
              ),
              TextField(
                obscureText: true,
                onChanged: (String content) {
                  password = content;
                },
                style: TextStyle(
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                    hintText: '输入密码'),
              ),
              TextButton(onPressed: _login, child: Text('登录')),
              Text('未注册的账号点击登录会自动注册')
            ],
          )),
        ));
  }
}
