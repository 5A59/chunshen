import 'package:flutter/material.dart';

import 'ball.dart';

///
/// 球的样式
///
class BallStyle {
  ///
  /// 尺寸
  ///
  final double size;

  ///
  /// 实心球颜色
  ///
  final Color color;

  ///
  /// 球的类型 [ BallType ]
  ///
  final BallType ballType;

  ///
  /// 边框宽
  ///
  final double borderWidth;

  ///
  /// 边框颜色
  ///
  final Color borderColor;

  const BallStyle(
      {this.size = 10,
      this.color = Colors.white,
      this.ballType = BallType.solid,
      this.borderWidth = 0,
      this.borderColor = Colors.white});
}
