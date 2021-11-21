import 'package:chunshen/model/index.dart';
import 'package:chunshen/net/index.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  String? username;
  String? password;

  @override
  void initState() {
    getPwd();
    super.initState();
  }

  void savePwd(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  void getPwd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    if (isEmpty(this.username)) {
      setState(() {
        this.username = username;
        this.password = password;
      });
    }
  }

  void _login() async {
    if (username == null || password == null) {
      toast('请输入账号和密码');
      return;
    }
    String md5Pwd = generateMd5(password!);
    CSResponse response = await UserModel.login(username, md5Pwd);
    if (CSResponse.success(response)) {
      toast('登录成功');
      savePwd(username!, password!);
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
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              image: AssetImage('assets/images/icon.jpeg')))),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    onChanged: (String content) {
                      username = content;
                    },
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    controller: TextEditingController()..text = username ?? '',
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 10, right: 10, top: 0, bottom: 0),
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
                    controller: TextEditingController()..text = password ?? '',
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 10, right: 10, top: 0, bottom: 0),
                        hintText: '输入密码'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    '未注册的账号点击登录会自动注册',
                    style: TextStyle(color: Color(CSColor.gray5)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: _login,
                      child: Text(
                        '登录',
                        style: TextStyle(
                            color: Color(CSColor.lightBlack), fontSize: 16),
                      )),
                ],
              )),
        ));
  }
}
