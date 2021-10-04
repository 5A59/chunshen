import 'package:chunshen/model/tag.dart';

class ExcerptUploadBean {
  String? id;
  String? content;
  String? comment;
  String? tagId;
  // 不给后端用，客户端用
  String? tagName;
  String? tagImage;

  ExcerptUploadBean(this.tagId, this.content, this.comment, {this.id});

  Map toJson() {
    Map map = Map();
    map['id'] = id;
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
    this.id = json['_id'];
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
  String? id;
  int? time;
  String? content;

  ExcerptCommentBean();
  ExcerptCommentBean.create(this.content, this.time);

  ExcerptCommentBean.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'];
    this.time = json['time'];
    this.content = json['content'];
  }
}

class CommentUploadBean {
  String? excerptId;
  String? content;

  CommentUploadBean(this.excerptId, this.content);

  Map toJson() {
    Map map = Map();
    map['content'] = content;
    map['excerptId'] = excerptId;
    return map;
  }
}

class DeleteBean {
  String id;
  DeleteBean(this.id);

  Map toJson() {
    Map map = Map();
    map['id'] = id;
    return map;
  }
}

class CommentDeleteBean extends DeleteBean {
  String excerptId;
  CommentDeleteBean(this.excerptId, String id) : super(id);

  Map toJson() {
    Map map = super.toJson();
    map['excerptId'] = excerptId;
    return map;
  }

}
