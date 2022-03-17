import 'package:chunshen/utils/index.dart';
import 'package:image_picker/image_picker.dart';

class TagBean {
  String? id;
  String? head;
  String? content;
  // 客户端使用
  String? publish;
  PickedFile? headFile;
  bool self = false;

  TagBean(this.id, this.head, this.content, this.publish, [this.self = false]);

  TagBean.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.head = json['head'];
    this.content = json['content'];
  }

  Map toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    if (!isEmpty(id)) {
      map['id'] = id;
    }
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
    this.list =
        (json['data'] as List?)?.map((e) => TagBean.fromJson(e)).toList() ?? [];
  }

  Map toJson() {
    Map map = Map();
    map['data'] = list.map((e) => e.toJson()).toList();
    return map;
  }
}
