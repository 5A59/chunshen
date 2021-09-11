import 'package:chunshen/style/index.dart';
import 'package:flutter/material.dart';

class TagItem extends StatefulWidget {
  String text = '';
  bool selected = false;
  Function(String text, bool selected)? onSelected;

  TagItem(this.text, this.selected, this.onSelected);

  @override
  State<StatefulWidget> createState() {
    return _TagItemState();
  }
}

class _TagItemState extends State<TagItem> {
  late bool selected = widget.selected;

  @override
  Widget build(BuildContext context) {
    int color = selected ? CSColor.blue : CSColor.gray4;
    return GestureDetector(
        onTap: () {
          setState(() {
            selected = !selected;
            widget.onSelected?.call(widget.text, selected);
          });
        },
        child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                border: Border.all(color: Color(color), width: 0.5),
                borderRadius: BorderRadius.circular(3)),
            child: Text(
              widget.text,
              style: TextStyle(color: Color(color)),
            )));
  }
}
