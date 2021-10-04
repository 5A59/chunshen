class TagBean {
  String? id;
  String? head;
  String? content;
  // 客户端使用
  String? publish;
  bool self = false;

  TagBean(this.id, this.head, this.content, this.publish);

  TagBean.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.head = json['head'];
    this.content = json['content'];
  }

  Map toJson() {
    Map map = Map();
    map['head'] = head;
    map['content'] = content;
    map['publish'] = publish;
    map['self'] = self;
    return map;
  }
}

class TagListBean {
  List<TagBean> list = [];

  TagListBean.fromJson(Map<String, dynamic> json) {
    this.list = (json['data'] as List).map((e) => TagBean.fromJson(e)).toList();
  }
}
