import 'dart:convert';

import 'package:chunshen/model/tag.dart';
import 'package:chunshen/utils/index.dart';

class ExcerptUploadBean {
  String? id;
  String? content;
  String? comment;
  String? tagId;
  // 不给后端用，客户端用
  String? tagName;
  String? tagImage;
  List<String>? image;

  ExcerptUploadBean(this.tagId, this.content, this.comment,
      {this.id, this.image});

  Map toJson() {
    Map map = Map();
    map['id'] = id;
    map['content'] = content;
    map['comment'] = comment;
    map['tagId'] = tagId;
    map['image'] = image;
    return map;
  }
}

class ExcerptListBean {
  List<ExcerptBean> content = [];

  ExcerptListBean(this.content);

  ExcerptListBean.fromJson(Map<String, dynamic> json) {
    this.content =
        (json['data'] as List?)?.map((e) => ExcerptBean.fromJson(e)).toList() ??
            [];
  }
}

class ExcerptBean {
  String? id;
  String? tagId;
  TagBean? tag;
  ExcerptContentBean? excerptContent;
  List<ExcerptCommentBean> comment = [];
  List<String>? image = [];
  bool update = false;

  ExcerptBean(this.id, this.tagId, this.tag, this.excerptContent, this.comment,
      this.image, this.update);

  ExcerptBean.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'];
    this.tag = TagBean.fromJson(json['tag']);
    this.tagId = json['tagId'];
    this.excerptContent = ExcerptContentBean.fromJson(json['content']);
    this.comment = (json['comment'] as List?)
            ?.map((e) => ExcerptCommentBean.fromJson(e))
            .toList() ??
        [];
    this.image = (json['image'] as List?)?.map((e) => e as String).toList();
  }

  Map toJson() {
    Map map = Map();
    map['_id'] = id;
    map['tag'] = tag?.toJson();
    if (!isEmpty(tagId)) {
      map['tagId'] = tagId;
    }
    map['content'] = excerptContent?.toJson();
    map['comment'] = comment;
    map['image'] = image;
    return map;
  }
}

class ExcerptContentBean {
  String? content;
  int? time;

  ExcerptContentBean(this.content, this.time);

  ExcerptContentBean.fromJson(Map<String, dynamic> json) {
    this.content = json['content'];
    this.time = json['time'];
  }

  Map toJson() {
    Map map = Map();
    map['content'] = content;
    map['time'] = time;
    return map;
  }
}

class ExcerptCommentBean {
  String? id;
  int? time;
  String? content;

  ExcerptCommentBean(this.id, this.content, this.time);
  ExcerptCommentBean.create(this.content, this.time);

  ExcerptCommentBean.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'];
    this.time = json['time'];
    this.content = json['content'];
  }

  Map toJson() {
    Map map = Map();
    map['_id'] = id;
    map['time'] = time;
    map['content'] = content;
    return map;
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
