import 'package:chunshen/model/excerpt.dart';
import 'package:chunshen/model/tag.dart';
import 'package:flutter/material.dart';
import 'package:chunshen/model/index.dart';

class ExcerptPage extends StatefulWidget {
  @override
  ExcerptState createState() => ExcerptState();
}

class TagWidget extends StatelessWidget {
  List<TagBean> list;

  TagWidget(this.list);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, i) {
        return Text(list[i].content ?? '');
      },
      itemCount: list.length,
    );
  }
}

class ExcerptCommentItem extends StatelessWidget {
  List<ExcerptCommentBean> comment = [];

  ExcerptCommentItem(this.comment);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, i) {
        return Padding(
            padding: EdgeInsets.only(left: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment[i].content ?? ''),
                Text(comment[i].time ?? '')
              ],
            ));
      },
      itemCount: comment.length,
    );
  }
}

class ExcerptContentItem extends StatelessWidget {
  ExcerptContentBean? bean;

  ExcerptContentItem(this.bean);

  @override
  Widget build(BuildContext context) {
    return this.bean != null
        ? Column(
            children: [
              Text(this.bean?.tag ?? ''),
              Text(this.bean?.content ?? ''),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          )
        : Spacer();
  }
}

class ExcerptItem extends StatelessWidget {
  ExcerptBean bean;

  ExcerptItem(this.bean);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.network(bean.excerptContent?.head ?? '',
                width: 100, height: 200),
            Flexible(
              child: ExcerptContentItem(bean.excerptContent),
            )
          ],
        ),
        ExcerptCommentItem(bean.comment)
      ],
    );
  }
}

class ExcerptState extends State<ExcerptPage>
    with AutomaticKeepAliveClientMixin {
  List<ExcerptBean> list = [];
  List<TagBean> tagList = [];
  int page = 0;

  @override
  void initState() {
    super.initState();
    getNextPageData();
  }

  void getTagList() async {
    Future.delayed(Duration(milliseconds: 500)).then((value) => {
          setState(() {
            TagListBean listBean = TagModel.getTagListBean();
            tagList.addAll(listBean.list);
          })
        });
  }

  void getNextPageData() async {
    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      setState(() {
        ExcerptListBean tmp = ExcerptModel.getExcerptListBean(page);
        list.addAll(tmp.content);
      });
      page++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TagWidget(tagList),
      ListView.builder(
        itemBuilder: (context, i) {
          if (i == list.length && list.length > 0) {
            getNextPageData();
            return Text('loading...');
          } else if (i < list.length) {
            // return Text(list[i].excerptContent?.content ?? 'null');
            return ExcerptItem(list[i]);
          } else {
            return Text('list empty');
          }
        },
        itemCount: list.length + 1,
      ),
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}
