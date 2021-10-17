class UserBean {
  String? username;
  String? password;

  UserBean(this.username, this.password);

  UserBean.fromJson(Map<String, dynamic> json) {
    this.username = json['username'];
    this.password = json['password'];
  }

  Map toJson() {
    Map map = Map();
    map['username'] = username;
    map['password'] = password;
    return map;
  }
}
