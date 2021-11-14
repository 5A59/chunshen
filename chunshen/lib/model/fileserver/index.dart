import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/tag.dart';
import 'package:chunshen/utils/index.dart';
import 'package:chunshen/utils/zip.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';

class FileServer {
  static const int PAGE_COUNT = 20;

  String path = 'chunshen/fileserver/tags';
  String tagListDir = 'chunshen/fileserver/';
  String relateTagListPath = 'chunshen/fileserver/tagList';
  String tagListPath = 'chunshen/fileserver/tagList';
  String serverDir = '';

  Map<String, List<String>> tagFiles = {};
  Map<String, String> excerptIdFiles = {};
  List<String> sortedFiles = [];
  Map<String, TagBean> tags = {};

  bool _hasInit = false;
  Lock _lock = Lock();

  factory FileServer() => _instance;
  static FileServer _instance = FileServer._();
  FileServer._();

  _getExtraPath() async {
    Directory? dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return dir;
  }

  exportExcerpts() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    Directory serverDir = Directory('$dir/chunshen');
    Directory targetDir = await _getExtraPath();
    String target = '${targetDir.path}/chunshen';
    String contentDir = '$target/content.zip';
    bool res = await ZipUtils.zip(serverDir.path, contentDir);
    if (!res) {
      return '';
    }
    File checkFile = File('$target/cc');
    checkFile.createSync();
    String md5Str = md5.convert(File(contentDir).readAsBytesSync()).toString();
    checkFile.writeAsStringSync(md5Str);
    String targetFile = '${targetDir.path}/chunshen.zip';
    res = await ZipUtils.zip(target, targetFile);
    if (!res) {
      return '';
    }
    return targetFile;
  }

  importExcerpts(String zipPath) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    String serverDir = '$dir/chunshen';
    bool res = await ZipUtils.unZip(zipPath, serverDir);
    if (!res) {
      return false;
    }
    String contentZip = '$serverDir/content.zip';
    String md5Str = md5.convert(File(contentZip).readAsBytesSync()).toString();
    File checkFile = File('$serverDir/cc');
    String comMd5 = checkFile.readAsStringSync().toString();
    if (comMd5 != md5Str) {
      return false;
    }
    res = await ZipUtils.unZip(contentZip, serverDir);
    File(contentZip).deleteSync();
    checkFile.deleteSync();
    return res;
  }

  Future<void> reInit() async {
    _hasInit = false;
    await _init();
  }

  Future<void> _init() async {
    await _lock.synchronized(() async {
      if (_hasInit) {
        return;
      }
      this.tagFiles = {};
      this.excerptIdFiles = {};
      this.sortedFiles = [];
      this.tags = {};
      String dir = (await getApplicationDocumentsDirectory()).path;
      this.serverDir = dir;
      _createFiles(dir);
      Directory serverDir = Directory('$dir/$path');
      if (serverDir.existsSync()) {
        serverDir.listSync().forEach((element) {
          List<String> tmp = [];
          tagFiles[_getRelativePath(element.path)] = tmp;
          List<String> excerpts = [];
          Directory(element.path).listSync().forEach((file) {
            String tmpPath = _getRelativePath(file.path);
            tmp.add(tmpPath);
            excerptIdFiles[getFileName(tmpPath)] = tmpPath;
            excerpts.add(tmpPath);
            sortedFiles.add(tmpPath);
          });
        });
        TagListBean tagListBean = await _getTagsInner();
        tagListBean.list.forEach((element) {
          tags[element.id!] = element;
        });
      }
      _hasInit = true;
    });
  }

  void _createFiles(String dir) {
    tagListPath = '$dir/$relateTagListPath';
    File file = File(tagListPath);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
  }

  String _getFullPath(String path) {
    return this.serverDir + '/' + path;
  }

  String _getRelativePath(String path) {
    return path.split(this.serverDir + '/')[1];
  }

  String getFileName(String file) {
    List<String> tmp = file.split('/');
    return tmp[tmp.length - 1];
  }

  getRambleData() async {
    await _init();
    List<String> list =
        pickRandomItems<String>(excerptIdFiles.values.toList(), PAGE_COUNT)
            .toList();
    List<ExcerptBean> beanList = [];
    await Future.forEach<String>(list, (e) async {
      String content = await File(_getFullPath(e)).readAsString();
      ExcerptBean excerptBean = _getExcerptInner(content);
      beanList.add(excerptBean);
    });
    return beanList;
  }

  sort(List<String> list) {
    list.sort((i1, i2) {
      return int.parse(getFileName(i2)) - int.parse(getFileName(i1));
    });
  }

  Future<ExcerptListBean> getExcerpts(int page, Set<String>? tags) async {
    await _init();
    List<String> files = [];
    if (isListEmpty(tags)) {
      tagFiles.values.forEach((element) {
        files.addAll(element);
      });
    } else {
      tags?.forEach((element) {
        files.addAll(tagFiles[element] ?? []);
      });
    }
    sort(files);
    int start = page * PAGE_COUNT;
    List<ExcerptBean> excerpts = [];
    if (start < files.length) {
      int end = min(start + PAGE_COUNT, files.length);
      List<String> tmpFiles = files.sublist(start, end);
      await Future.forEach<String>(tmpFiles, (element) async {
        String content = await File(_getFullPath(element)).readAsString();
        ExcerptBean excerptBean = _getExcerptInner(content);
        excerpts.add(excerptBean);
      });
    }
    ExcerptListBean excerptListBean = ExcerptListBean(excerpts);
    return excerptListBean;
  }

  _getExcerptInner(String content) {
    Map<String, dynamic> tmp = csJsonDecode(content);
    tmp['tag'] = this.tags[tmp['tagId'] as String]?.toJson();
    ExcerptBean excerptBean = ExcerptBean.fromJson(tmp);
    return excerptBean;
  }

  addComment(String excerptId, String content) async {
    await _init();
    String? path = excerptIdFiles[excerptId];
    if (path == null) {
      return false;
    }
    String realPath = _getFullPath(path);
    String excerptContent = await File(realPath).readAsString();
    ExcerptBean excerptBean = _getExcerptInner(excerptContent);
    int id = DateTime.now().millisecondsSinceEpoch;
    ExcerptCommentBean commentBean =
        ExcerptCommentBean('$excerptId $id', content, id);
    excerptBean.comment.add(commentBean);
    await File(realPath).writeAsString(jsonEncode(excerptBean));
    return commentBean;
  }

  deleteComment(String excerptId, String id) async {
    await _init();
    String? path = excerptIdFiles[excerptId];
    if (path == null) {
      return false;
    }
    String content = await File(_getFullPath(path)).readAsString();
    ExcerptBean excerptBean = ExcerptBean.fromJson(csJsonDecode(content));
    ExcerptCommentBean? commentBean;
    excerptBean.comment.forEach((element) {
      if (element.id == id) {
        commentBean = element;
      }
    });
    if (commentBean != null) {
      excerptBean.comment.remove(commentBean);
    }
    await File(_getFullPath(path)).writeAsString(jsonEncode(excerptBean));
  }

  deleteExcerpt(String id) async {
    await _init();
    await File(_getFullPath(excerptIdFiles[id] ?? '')).delete();
    String path = excerptIdFiles[id] ?? '';
    excerptIdFiles.remove(id);
    tagFiles.values.forEach((element) {
      if (element.contains(path)) {
        element.remove(path);
      }
    });
  }

  addExcerpt(
      String content, String comment, String tagId, List<String> images) async {
    await _init();
    String id = '${DateTime.now().millisecondsSinceEpoch}';
    ExcerptBean bean = ExcerptBean(
        id,
        tagId,
        null,
        ExcerptContentBean(content, null),
        isEmpty(comment) ? [] : [ExcerptCommentBean(null, comment, null)],
        images,
        false);
    String path = tagId + '/' + id;
    File file = File(_getFullPath(path));
    if (!file.existsSync()) {
      file.createSync();
    }
    await file.writeAsString(jsonEncode(bean.toJson()));
    tagFiles[tagId]?.add(path);
    excerptIdFiles[id] = path;
  }

  updateExcerpt(
      String id, String content, String tagId, List<String> images) async {
    await _init();
    String path = excerptIdFiles[id] ?? '';
    String exContent = await File(_getFullPath(path)).readAsString();
    ExcerptBean bean = _getExcerptInner(exContent);
    bean.excerptContent?.content = content;
    bean.image = images;
    await File(_getFullPath(path)).writeAsString(jsonEncode(bean));
  }

  addTag(TagBean bean) async {
    await _init();
    String path = this.path + '/' + (bean.content ?? '');
    Directory(this.serverDir + '/' + path).createSync(recursive: true);
    tagFiles[path] = [];
    bean.id = path;
    String tags = await File(tagListPath).readAsString();
    TagListBean beanList = TagListBean.fromJson(csJsonDecode(tags));
    beanList.list.add(bean);
    this.tags[path] = bean;
    await File(tagListPath).writeAsString(jsonEncode(beanList.toJson()));
  }

  deleteTag(String id) async {
    await _init();
    Directory(_getFullPath(id)).deleteSync(recursive: true);
    String tags = await File(tagListPath).readAsString();
    TagListBean beanList = TagListBean.fromJson(csJsonDecode(tags));

    TagBean? bean;
    beanList.list.forEach((element) {
      if (element.id == id) {
        bean = element;
      }
    });
    beanList.list.remove(bean);
    await File(tagListPath).writeAsString(jsonEncode(beanList));
    return beanList;
  }

  getTags() async {
    await _init();
    return await _getTagsInner();
  }

  _getTagsInner() async {
    String tags = await File(tagListPath).readAsString();
    if (isEmpty(tags)) {
      tags = '{}';
    }
    TagListBean beanList = TagListBean.fromJson(csJsonDecode(tags));
    beanList.list = beanList.list.reversed.toList();
    return beanList;
  }
}
