import 'package:chunshen/utils/index.dart';

class Global {
  static String? username;
  static List<Function> onLoginListener = [];

  static void addLoginListener(Function listener) {
    onLoginListener.add(listener);
  }

  static void onLogin() {
    onLoginListener.forEach((element) {
      element.call();
    });
  }

  static bool isLogin() {
    return isEmpty(username);
  }
}
