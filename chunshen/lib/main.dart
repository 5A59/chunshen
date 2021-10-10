import 'package:chunshen/config.dart';
import 'package:chunshen/input/text/index.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/tag/add_tag/index.dart';
import 'package:chunshen/tag/manage_tag/index.dart';
import 'package:flutter/material.dart';
import 'package:chunshen/main/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: Color(CSColor.white),
          primaryColor: Color(CSColor.white)),
      home: MyHomePage(),
      initialRoute: 'home',
      onGenerateRoute: (RouteSettings settings) {
        Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
          PAGE_HOME: (context) => MyHomePage(),
          PAGE_TEXT_INPUT: (context) => TextInputPage(
                settings: settings,
              ),
          PAGE_ADD_TAG: (context) => AddTagPage(),
          PAGE_MANAGE_TAG: (context) => ManageTagPage(),
        };
        WidgetBuilder builder = routes[settings.name]!;
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      },
      // routes: {
      //   PAGE_HOME: (context) => MyHomePage(),
      //   PAGE_TEXT_INPUT: (context) => TextInputPage(),
      //   PAGE_ADD_TAG: (context) => AddTagPage(),
      //   PAGE_MANAGE_TAG: (context) => ManageTagPage(),
      // },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: SafeArea(
        child: MainPage(),
      ),
    );
  }
}
