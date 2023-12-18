import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WaterFlowAnimation extends StatelessWidget {
  final AnimationController controller;
  const WaterFlowAnimation({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          height: 98,
          width: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            gradient: LinearGradient(
              colors: const [
                Colors.transparent,
                Colors.white,
                Colors.transparent
              ],
              stops: const [0.3, 0.5, 0.7],
              begin: Alignment(controller.value - 1, 0),
              end: Alignment(controller.value + 1, 0),
            ),
          ),
        );
      },
    );
  }
}
