import 'package:chunshen/model/fileserver/index.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/model/spider/index.dart';
import 'package:chunshen/model/tag.dart';
import 'package:chunshen/net/index.dart';
import 'package:chunshen/utils/index.dart';

import 'excerpt.dart';

class ExcerptFileModel extends ExcerptModel {
  static Future<ExcerptListBean> getExcerptListBean(
      int page, Set<String>? tags) async {
    return FileServer().getExcerpts(page, tags);
  }

  static Future<CSResponse> uploadNewExcerpt(ExcerptUploadBean bean) async {
    if (!isEmpty(bean.id)) {
      await FileServer().updateExcerpt(bean.id ?? '', bean.content ?? '',
          bean.tagId ?? '', bean.image ?? []);
      CSResponse resp = CSResponse.normal(error: bean.id ?? '');
      return resp;
    }
    String id = await FileServer().addExcerpt(bean.content ?? '',
        bean.comment ?? '', bean.tagId ?? '', bean.image ?? []);
    CSResponse resp = CSResponse.normal(error: id);
    return resp;
  }
}

class TagFileModel extends TagModel {
  static Future<TagListBean> getTagListBean() async {
    return await FileServer().getTags();
  }

  static search(String tag) async {
    return DoubanSpider().search(tag);
  }

  static addTag(TagBean tag) async {
    int status = await FileServer().addTag(tag);
    if (status == 0) {
      return CSResponse.normal();
    } else if (status == 1) {
      return CSResponse.error(error: '书籍已存在~');
    }
    return CSResponse.normal();
  }

  static updateTag(TagBean newTag, TagBean oldTag) async {
    await FileServer().updateTag(newTag, oldTag);
    CSResponse resp = CSResponse.normal();
    return resp;
  }
}

class RambleFileModel extends RambleModel {
  static Future<List<ExcerptBean>> getRambleData() async {
    return await FileServer().getRambleData();
  }
}

class CommentFileModel extends CommentModel {
  static Future<ExcerptCommentBean?> uploadNewComment(
      String? excerptId, String? content) async {
    return await FileServer().addComment(excerptId ?? '', content ?? '');
  }
}

class DeleteFileModel extends DeleteModel {
  static Future<CSResponse> deleteExcerpt(String? id) async {
    if (id == null) {
      return CSResponse.error();
    }
    await FileServer().deleteExcerpt(id);
    return CSResponse.normal();
  }

  static Future<CSResponse> deleteTag(String? id) async {
    if (id == null) {
      return CSResponse.error();
    }
    await FileServer().deleteTag(id);
    return CSResponse.normal();
  }

  static Future<CSResponse> deleteComment(String? excerptId, String? id) async {
    if (id == null || excerptId == null) {
      return CSResponse.error();
    }
    await FileServer().deleteComment(excerptId, id);
    return CSResponse.normal();
  }
}
