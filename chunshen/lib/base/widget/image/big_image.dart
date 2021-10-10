import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'cs_image.dart';

// ignore: must_be_immutable
class BigImagePage extends StatefulWidget {
  List<String> images;
  int initialPage = 0;
  BigImagePage(this.images, this.initialPage);

  static void openBigImage(BuildContext context, List<String> images,
      {int initialPage = 0}) {
    openPageRaw(
        context,
        new MaterialPageRoute(
            builder: (context) => new BigImagePage(images, initialPage)));
  }

  @override
  _BigImagePageState createState() => _BigImagePageState();
}

class _BigImagePageState extends State<BigImagePage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Scaffold(
          body: SafeArea(
              child: Container(
                  child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              String url = widget.images[index];
              return PhotoViewGalleryPageOptions(
                imageProvider: CSImage.getImageProviderByUrl(url),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: widget.images[index]),
              );
            },
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(),
              ),
            ),
            itemCount: widget.images.length,
            backgroundDecoration: BoxDecoration(color: Colors.white),
            pageController: PageController(initialPage: widget.initialPage),
            // onPageChanged: onPageChanged,
          ))),
        ));
  }
}
