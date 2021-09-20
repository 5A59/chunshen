import 'package:chunshen/model/tag.dart';

class ExcerptUploadBean {
  String? content;
  String? comment;
  String? tagId;

  ExcerptUploadBean(this.tagId, this.content, this.comment);

  Map toJson() {
    Map map = Map();
    map['content'] = content;
    map['comment'] = comment;
    map['tagId'] = tagId;
    return map;
  }
}

class ExcerptListBean {
  List<ExcerptBean> content = [];

  ExcerptListBean.fromJson(Map<String, dynamic> json) {
    this.content =
        (json['data'] as List?)?.map((e) => ExcerptBean.fromJson(e)).toList() ??
            [];
  }
}

class ExcerptBean {
  String? id;
  TagBean? tag;
  ExcerptContentBean? excerptContent;
  List<ExcerptCommentBean> comment = [];

  ExcerptBean.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.tag = TagBean.fromJson(json['tag']);
    this.excerptContent = ExcerptContentBean.fromJson(json['content']);
    this.comment = (json['comment'] as List?)
            ?.map((e) => ExcerptCommentBean.fromJson(e))
            .toList() ??
        [];
  }
}

class ExcerptContentBean {
  String? content;
  int? time;

  ExcerptContentBean.fromJson(Map<String, dynamic> json) {
    this.content = json['content'];
    this.time = json['time'];
  }
}

class ExcerptCommentBean {
  int? time;
  String? content;
  ExcerptCommentBean.fromJson(Map<String, dynamic> json) {
    this.time = json['time'];
    this.content = json['content'];
  }
}
