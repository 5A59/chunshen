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
  bool dismissWhenNoTag = false;
  String? defaultText = '';

  TagWidget(this.onTagSelected,
      {Key? key,
      this.multiSelect = true,
      this.defaultTags,
      this.showAdd = false,
      this.dismissWhenNoTag = false,
      this.defaultText})
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
    TagListBean value = await TagModel.getTagListBean();
    setState(() {
      tagList = value.list;
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

  Widget buildTagList(String? defaultText) {
    List<TagBean> list = tagList;
    return (list.length > 0 || !widget.dismissWhenNoTag)
        ? Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(bottom: 10),
            color: Color(CSColor.white),
            child: SizedBox(
              height: 30,
              child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Stack(children: [
                    if (list.length > 0)
                      Expanded(
                          child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          if (i < list.length) {
                            return buildTagItem(list[i]);
                          }
                          return SizedBox(
                            width: 30,
                          );
                        },
                        itemCount: list.length + 1,
                      )),
                    if (list.length <= 0 && defaultText != null)
                      Expanded(
                          child: Text(
                        defaultText,
                        style: TextStyle(color: Color(CSColor.gray5)),
                      )),
                    SizedBox(
                      width: 10,
                    ),
                    Positioned(
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromRGBO(255, 255, 255, 0.1),
                                Color.fromRGBO(255, 255, 255, 1),
                                Color.fromRGBO(255, 255, 255, 1),
                                Color.fromRGBO(255, 255, 255, 1),
                                if (widget.showAdd)
                                  Color.fromRGBO(255, 255, 255, 1),
                                if (widget.showAdd)
                                  Color.fromRGBO(255, 255, 255, 1),
                                if (widget.showAdd)
                                  Color.fromRGBO(255, 255, 255, 1),
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              if (widget.showAdd)
                                SizedBox(
                                    width: 50,
                                    child: IconButton(
                                        alignment: Alignment.topRight,
                                        padding: EdgeInsets.all(0),
                                        onPressed: addTag,
                                        icon: Icon(Icons.add))),
                              SizedBox(
                                  width: 40,
                                  child: IconButton(
                                      alignment: Alignment.topRight,
                                      onPressed: () {
                                        dialogDown();
                                      },
                                      padding: EdgeInsets.all(0),
                                      icon: Icon(Icons.arrow_drop_down)))
                            ],
                          ),
                        ))
                  ])),
            ))
        : Container();
  }

  Widget buildTagPanel() {
    List<TagBean> list = tagList;
    return Column(children: [
      Container(
          width: MediaQuery.of(context).size.width,
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
                // Positioned(
                //     child: SizedBox(
                //   height: 30,
                //   child: Row(
                //     children: [
                //       Spacer(),
                //       Container(
                //         color: Color(CSColor.white),
                //         child: SizedBox(
                //           width: 50,
                //             child: IconButton(
                //                 alignment: Alignment.topRight,
                //                 onPressed: () {
                //                   dialogUp();
                //                 },
                //                 icon: Icon(Icons.arrow_drop_up))),
                //       )
                //     ],
                //   ),
                // )),
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
        child: Container(
            child: !down ? buildTagList(widget.defaultText) : buildTagPanel()));
  }
}
