import 'package:cached_network_image/cached_network_image.dart';
import 'package:chunshen/style/index.dart';
import 'package:chunshen/utils/index.dart';
import 'package:flutter/material.dart';

class CSImage {
  static Widget buildImage(String? url, double width, double height) {
    return !isEmpty(url)
        ? CachedNetworkImage(
            width: width,
            height: height,
            imageUrl: url!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Color(CSColor.gray),
            ),
            errorWidget: (context, url, error) => Container(
              color: Color(CSColor.gray),
            ),
          )
        : SizedBox(
            width: width,
            height: height,
            child: Container(
              color: Color(CSColor.gray),
            ),
          );
  }
}
