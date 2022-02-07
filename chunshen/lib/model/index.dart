import 'package:chunshen/model/file_model.dart';
import 'package:chunshen/model/spider/index.dart';
import 'package:chunshen/model/tag.dart';
import 'package:chunshen/model/user.dart';
import 'package:chunshen/net/index.dart';

import 'excerpt.dart';

import 'net_model.dart';

class BaseModel {
  static const int _TYPE_NET = 0;
  static const int _TYPE_FILE = 1;
  static int _type = _TYPE_FILE;

  static useNetServer() {
    _type = _TYPE_NET;
  }

  static useFileServer() {
    _type = _TYPE_FILE;
  }

  static isNet() {
    return _type == _TYPE_NET;
  }
}

class ExcerptModel {
  static Future<ExcerptListBean> getExcerptListBean(
      int page, Set<String>? tags) async {
    return BaseModel.isNet()
        ? ExcerptNetModel.getExcerptListBean(page, tags)
        : ExcerptFileModel.getExcerptListBean(page, tags);
  }

  // TODO: 添加新书摘以后，服务端需要返回 id，否则本地更新会有 bug，因为没有 id，再次编辑无法删除
  static Future<CSResponse> uploadNewExcerpt(ExcerptUploadBean bean) async {
    return BaseModel.isNet()
        ? ExcerptNetModel.uploadNewExcerpt(bean)
        : ExcerptFileModel.uploadNewExcerpt(bean);
  }
}

class TagModel {
  static Future<TagListBean> getTagListBean() async {
    return BaseModel.isNet()
        ? TagNetModel.getTagListBean()
        : TagFileModel.getTagListBean();
  }

  static search(String tag) async {
    return DoubanSpider().search(tag);
  }

  static addTag(TagBean tag) async {
    return BaseModel.isNet()
        ? TagNetModel.addTag(tag)
        : TagFileModel.addTag(tag);
  }

  static updateTag(TagBean newTag, TagBean oldTag) async {
    return BaseModel.isNet() ? '' : TagFileModel.updateTag(newTag, oldTag);
  }
}

class RambleModel {
  static Future<List<ExcerptBean>> getRambleData() async {
    return BaseModel.isNet()
        ? RambleNetModel.getRambleData()
        : RambleFileModel.getRambleData();
  }
}

class CommentModel {
  static Future<ExcerptCommentBean?> uploadNewComment(
      String? excerptId, String? content) async {
    return BaseModel.isNet()
        ? CommentNetModel.uploadNewComment(excerptId, content)
        : CommentFileModel.uploadNewComment(excerptId, content);
  }
}

class DeleteModel {
  static Future<CSResponse> deleteExcerpt(String? id) async {
    if (id == null) {
      return CSResponse.error();
    }
    return BaseModel.isNet()
        ? DeleteNetModel.deleteExcerpt(id)
        : DeleteFileModel.deleteExcerpt(id);
  }

  static Future<CSResponse> deleteTag(String? id) async {
    if (id == null) {
      return CSResponse.error();
    }
    return BaseModel.isNet()
        ? DeleteNetModel.deleteTag(id)
        : DeleteFileModel.deleteTag(id);
  }

  static Future<CSResponse> deleteComment(String? excerptId, String? id) async {
    if (id == null || excerptId == null) {
      return CSResponse.error();
    }
    return BaseModel.isNet()
        ? DeleteNetModel.deleteComment(excerptId, id)
        : DeleteFileModel.deleteComment(excerptId, id);
  }
}

class UserModel {
  static Future<CSResponse> login(String? username, String? password) async {
    if (username == null || password == null) {
      return CSResponse.error();
    }
    CSResponse response =
        await httpPost('/user/login', body: UserBean(username, password));
    return response;
  }
}
