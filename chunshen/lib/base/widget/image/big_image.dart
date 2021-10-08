import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class BigImage extends StatelessWidget {
  List<String> images;
  BigImage(this.images);

  static void openBigImage(BuildContext context, List<String> images) {
    openPageRaw(context,
        new MaterialPageRoute(builder: (context) => new BigImage(images)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(images[index]),
          initialScale: PhotoViewComputedScale.contained * 0.8,
          // heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
        );
      },
      itemCount: images.length,
      // backgroundDecoration: widget.backgroundDecoration,
      // pageController: widget.pageController,
      // onPageChanged: onPageChanged,
    ));
  }
}
