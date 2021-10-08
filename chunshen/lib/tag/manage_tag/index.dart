import 'package:cached_network_image/cached_network_image.dart';
import 'package:chunshen/base/widget/image/cs_image.dart';
import 'package:chunshen/config.dart';
import 'package:chunshen/model/index.dart';
import 'package:chunshen/model/tag.dart';
import 'package:chunshen/net/index.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';

class ManageTagPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ManageTagState();
  }
}

class _ManageTagState extends State<ManageTagPage> {
  String? content;
  List<TagBean> tagList = [];
  Offset? _tapPosition;
  bool changed = false;

  @override
  void initState() {
    _load();
    super.initState();
  }

  void _load() async {
    TagListBean value = await TagModel.getTagListBean();
    setState(() {
      tagList = value.list;
    });
  }

  _deleteTag(TagBean bean) async {
    CSResponse resp = await DeleteModel.deleteTag(bean.id);
    if (CSResponse.success(resp)) {
      toast('删除成功');
      _load();
      changed = true;
    } else {
      toast('删除失败，请稍后重试～');
    }
  }

  _showMenu(TagBean bean) {
    if (_tapPosition != null) {
      showMenuAtPosition(context, _tapPosition!, [
        PopupMenuItem(
          child: Text('删除'),
          value: 'delete',
        )
      ], onSelected: (value) {
        if (value == 'delete') {
          showNorlmalDialog(context, '提示', '是否确认删除书籍？\n删除书籍后，书籍所关联的所有书摘都会被删除',
              '取消', '确认', null, () {
            _deleteTag(bean);
          });
        }
      });
    }
  }

  _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  Widget _buildItem(TagBean bean) {
    return GestureDetector(
        onTapDown: _storePosition,
        onLongPress: () {
          _showMenu(bean);
        },
        child: Container(
          child: Column(
            children: [
              CSImage.buildImage(bean.head, 70, 100),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: Text(
                bean.content ?? '',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ))
            ],
          ),
        ));
  }

  _addTag() async {
    var res = await openPage(context, PAGE_ADD_TAG);
    if (res == true) {
      changed = true;
      _load();
    }
  }

  Widget _buildAddTag() {
    return GestureDetector(
        onTap: _addTag,
        child: Column(
          children: [
            Container(
                width: 70,
                height: 100,
                color: Color(CSColor.gray),
                child: Icon(Icons.add))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(CSColor.white),
            title: Text('管理书籍')),
        body: WillPopScope(
            onWillPop: () async {
              finishPage(context, params: changed);
              return false;
            },
            child: Container(
                padding: EdgeInsets.all(10),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //横轴元素个数
                    crossAxisCount: 3,
                    //纵轴间距
                    mainAxisSpacing: 5.0,
                    //横轴间距
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return _buildAddTag();
                    } else {
                      return _buildItem(tagList[index - 1]);
                    }
                  },
                  itemCount: tagList.length + 1,

                  ///GridView中使用的子Widegt
                ))));
  }
}
