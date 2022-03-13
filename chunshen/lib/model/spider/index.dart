import 'package:chunshen/model/tag.dart';
import 'package:chunshen/net/index.dart';
import 'package:dio/dio.dart';

class DoubanSpider {
  List<TagBean> filterBooks(content) {
    List<TagBean> list = [];
    String reg =
        r'<div class="result"[\s\S]*?<a class="nbg"[\s\S]*?title="(?<title>[\s\S]*?)"[\s\S]*?<img src="(?<img>.*?)"[\s\S]*?\[.*?\][\s\S]*?<span class="subject-cast">(.*?)<';
    RegExp regExp = RegExp(reg);
    regExp.allMatches(content).forEach((element) {
      if (element.group(0)?.contains('书籍') ?? false) {
        list.add(TagBean(
            null, element.group(2), element.group(1), element.group(3)));
        // print(element.group(1) ?? 'null' + '  ' + (element.group(2) ?? 'null'));
      }
    });
    return list;
  }

  Future<List<TagBean>> search(String book) async {
    String path = 'https://www.douban.com/search';
    Response response = await rawGet(path, query: {'q': book});
    String res = response.data.toString();
    List<TagBean> list = [];
    try {
      list = filterBooks(res);
    } on Exception catch (e) {}
    return list;
  }
}
