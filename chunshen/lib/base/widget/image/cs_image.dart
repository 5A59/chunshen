import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chunshen/model/fileserver/index.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';

class CSImage {
  static Widget buildImage(String? url, double? width, double? height) {
    return !isEmpty(url)
        ? getImageByUrl(url!, width, height)
        : SizedBox(
            width: width,
            height: height,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Image(image: AssetImage('assets/images/icon_no_bg.png')),
              color: Color(CSColor.gray),
            ),
          );
  }

  static Widget getImageByUrl(String url, double? width, double? height) {
    if (url.startsWith('http')) {
      return CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Color(CSColor.gray),
        ),
        errorWidget: (context, url, error) => Container(
          color: Color(CSColor.gray),
        ),
      );
    } else if (url.startsWith('csfileserver://')) {
      String tmp = FileServer().getFullImagePath(url);
      return Image.file(
        File(tmp),
        fit: BoxFit.cover,
        width: width,
        height: height,
      );
    } else if (File(url).existsSync()) {
      return Image.file(
        File(url),
        fit: BoxFit.cover,
        width: width,
        height: height,
      );
    } else {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        width: width,
        height: height,
      );
    }
  }

  static ImageProvider getImageProviderByUrl(String url) {
    if (url.startsWith('http')) {
      return CachedNetworkImageProvider(url);
    } else if (url.startsWith('csfileserver://')) {
      String tmp = FileServer().getFullImagePath(url);
      return FileImage(File(tmp));
    } else if (File(url).existsSync()) {
      return FileImage(File(url));
    } else {
      return AssetImage(url);
    }
  }
}
