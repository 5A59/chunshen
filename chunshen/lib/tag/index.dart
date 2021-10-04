import 'package:chunshen/model/index.dart';
import 'package:chunshen/model/tag.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/tag/tag_item.dart';
import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';

import '../config.dart';

class TagWidget extends StatefulWidget {
  Function(Set<String>, List<TagBean>)? onTagSelected;
  List<String>? defaultTags;
  bool multiSelect = true;
  bool showAdd = false;

  TagWidget(this.onTagSelected,
      {Key? key,
      this.multiSelect = true,
      this.defaultTags,
      this.showAdd = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TagWidgetState();
  }
}

class TagWidgetState extends State<TagWidget> {
  bool down = false;
  Set<String> tags = Set();
  List<TagBean> tagList = [];

  @override
  void initState() {
    tags.addAll(widget.defaultTags ?? []);
    refresh();
    super.initState();
  }

  void refresh() async {
    TagModel.getTagListBean().then((value) {
      setState(() {
        tagList = value.list;
      });
    });
  }

  dialogDown() {
    setState(() {
      down = true;
    });
  }

  dialogUp() {
    setState(() {
      down = false;
    });
  }

  onTagSelected(TagBean? tag, bool selected) {
    if (widget.multiSelect) {
      if (selected) {
        tags.add(tag?.id ?? '');
      } else {
        tags.remove(tag?.id ?? '');
      }
    } else {
      setState(() {
        tags = Set();
        if (selected) {
          tags.add(tag?.id ?? '');
        }
      });
    }
    widget.onTagSelected?.call(tags, tagList);
  }

  bool tagSelected(TagBean tag) {
    return tags.contains(tag.id);
  }

  addTag() async {
    Object? res = await openPage(context, PAGE_ADD_TAG);
    if (res == true) {
      refresh();
    }
  }

  Widget buildTagItem(TagBean tag) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: TagItem(tag, tagSelected(tag), onTagSelected),
    );
  }

  Widget buildTagList() {
    List<TagBean> list = tagList;
    return Container(
        padding: EdgeInsets.only(bottom: 10),
        color: Color(CSColor.white),
        child: SizedBox(
          height: 30,
          child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(children: [
                Expanded(
                    child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return buildTagItem(list[i]);
                  },
                  itemCount: list.length,
                )),
                SizedBox(
                  width: 10,
                ),
                if (widget.showAdd)
                  IconButton(onPressed: addTag, icon: Icon(Icons.add)),
                IconButton(
                    onPressed: () {
                      dialogDown();
                    },
                    icon: Icon(Icons.arrow_drop_down))
              ])),
        ));
  }

  Widget buildTagPanel() {
    List<TagBean> list = tagList;
    return Column(children: [
      Container(
          decoration: BoxDecoration(color: Color(CSColor.white)),
          padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 500),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Wrap(
                    direction: Axis.horizontal,
                    runSpacing: 10,
                    children: list.map((e) {
                      return buildTagItem(e);
                    }).toList(),
                  ),
                ),
                Positioned(
                    child: SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Spacer(),
                      Container(
                        color: Color(CSColor.white),
                        child: IconButton(
                            onPressed: () {
                              dialogUp();
                            },
                            icon: Icon(Icons.arrow_drop_up)),
                      )
                    ],
                  ),
                )),
              ],
            ),
          )),
      Expanded(
          child: GestureDetector(
              onTap: () {
                dialogUp();
              },
              child: Container(
                decoration: BoxDecoration(color: Color(CSColor.gray5)),
              )))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: Container(child: !down ? buildTagList() : buildTagPanel()));
  }
}
