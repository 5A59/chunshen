class ExcerptListBean {
  List<ExcerptBean> content = [];

  ExcerptListBean.fromJson(Map<String, dynamic> json) {
    this.content =
        (json['data'] as List).map((e) => ExcerptBean.fromJson(e)).toList();
  }
}

class ExcerptBean {
  ExcerptContentBean? excerptContent;
  List<ExcerptCommentBean> comment = [];

  ExcerptBean.fromJson(Map<String, dynamic> json) {
    this.excerptContent = ExcerptContentBean.fromJson(json['content']);
    this.comment = (json['comment'] as List?)
        ?.map((e) => ExcerptCommentBean.fromJson(e))
        .toList() ?? [];
  }
}

class ExcerptContentBean {
  String? content;
  String? head;
  String? tag;

  ExcerptContentBean.fromJson(Map<String, dynamic> json) {
    this.content = json['content'];
    this.head = json['head'];
    this.tag = json['tag'];
  }
}

class ExcerptCommentBean {
  String? time;
  String? content;
  ExcerptCommentBean.fromJson(Map<String, dynamic> json) {
    this.time = json['time'];
    this.content = json['content'];
  }
}
