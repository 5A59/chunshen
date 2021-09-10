import 'package:flutter/material.dart';
import './delay_tween.dart';
import 'ball.dart';

///
/// desc:
///

class BallBounceLoading extends StatefulWidget {
  final Duration duration;
  final Curve curve;

  const BallBounceLoading(
      {this.duration = const Duration(milliseconds: 800),
      this.curve = Curves.linear})
      : super();
  @override
  _BallBounceLoadingState createState() => _BallBounceLoadingState();
}

class _BallBounceLoadingState extends State<BallBounceLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Animation> _animations = [];

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
    List.generate(3, (index) {
      _animations.add(DelayTween(0.0, 1.0, 0.2 * index)
          .animate(CurvedAnimation(parent: _controller, curve: widget.curve)));
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Align(
                  alignment: Alignment(0.0, 0.4 * _animations[index].value),
                  child: Ball());
            },
          ),
        );
      }),
    );
  }
}
