import 'package:chunshen/model/tag.dart';
import 'package:chunshen/style/index.dart';
import 'package:flutter/material.dart';

class TagItem extends StatefulWidget {
  TagBean? tag;
  bool selected = false;
  Function(TagBean? tag, bool selected)? onSelected;

  TagItem(this.tag, this.selected, this.onSelected);

  @override
  State<StatefulWidget> createState() {
    return _TagItemState();
  }
}

class _TagItemState extends State<TagItem> {
  @override
  Widget build(BuildContext context) {
    late bool selected = widget.selected;
    int color = selected ? CSColor.yellow : CSColor.gray4;
    return GestureDetector(
        onTap: () {
          setState(() {
            selected = !selected;
            widget.onSelected?.call(widget.tag, selected);
          });
        },
        child: !selected
            ? SizedBox(
                height: 30,
                child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(CSColor.gray3), width: 0.5),
                            borderRadius: BorderRadius.circular(3)),
                        child: Text(
                          widget.tag?.content ?? '',
                          style: TextStyle(
                              fontSize: 11,
                              color: Color(color),
                              fontWeight: FontWeight.bold),
                        ))))
            : SizedBox(
                height: 30,
                child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Color(color),
                            border: Border.all(color: Color(color), width: 0.5),
                            borderRadius: BorderRadius.circular(3)),
                        child: Text(
                          widget.tag?.content ?? '',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )))));
  }
}
