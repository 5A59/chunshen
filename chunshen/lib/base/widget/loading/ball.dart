import 'package:chunshen/style/index.dart';
import 'package:flutter/material.dart';

import 'ball_style.dart';

/// 默认球的样式
const _kDefaultBallStyle = BallStyle(
  size: 6.0,
  color: Color(CSColor.gray2),
  ballType: BallType.solid,
  borderWidth: 0.0,
  borderColor: Color(CSColor.gray2),
);

/// desc:球
class Ball extends StatelessWidget {
  const Ball() : super();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kDefaultBallStyle.size,
      height: _kDefaultBallStyle.size,
      child: DecoratedBox(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _kDefaultBallStyle.ballType == BallType.solid
                ? _kDefaultBallStyle.color
                : null,
            border: Border.all(
                color: _kDefaultBallStyle.borderColor,
                width: _kDefaultBallStyle.borderWidth)),
      ),
    );
  }
}

enum BallType {
  /// 空心
  hollow,

  /// 实心
  solid
}
