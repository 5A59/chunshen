class TagBean {
  String? head;
  String? content;

  TagBean._();

  TagBean.fromJson(Map<String, dynamic> json) {
    this.head = json['head'];
    this.content = json['content'];
  }
}

class TagListBean {
  List<TagBean> list = [];

  TagListBean.fromJson(Map<String, dynamic> json) {
    this.list = (json['data'] as List).map((e) => TagBean.fromJson(e)).toList();
  }
}
