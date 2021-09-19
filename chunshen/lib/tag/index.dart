import 'package:chunshen/model/index.dart';
import 'package:chunshen/model/tag.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/tag/tag_item.dart';
import 'package:flutter/material.dart';

class TagWidget extends StatefulWidget {
  Function(Set<String>)? onTagSelected;
  bool multiSelect = true;

  TagWidget(this.onTagSelected, {Key? key, this.multiSelect = true})
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

  onTagSelected(String text, bool selected) {
    if (widget.multiSelect) {
      if (selected) {
        tags.add(text);
      } else {
        tags.remove(text);
      }
    } else {
      setState(() {
        tags = Set();
        if (selected) {
          tags.add(text);
        }
      });
    }
    widget.onTagSelected?.call(tags);
  }

  bool tagSelected(String text) {
    return tags.contains(text);
  }

  Widget buildTagItem(String text) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: TagItem(text, tagSelected(text), onTagSelected),
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
                    String text = list[i].content ?? '';
                    return buildTagItem(text);
                  },
                  itemCount: list.length,
                )),
                SizedBox(
                  width: 10,
                ),
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
                      String text = e.content ?? '';
                      return buildTagItem(text);
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
