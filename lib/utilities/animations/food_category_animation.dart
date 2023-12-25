import 'package:flutter/material.dart';

class FoodCategoryAnimation extends StatelessWidget {
  final AnimationController controller;
  const FoodCategoryAnimation({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 54,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                color: const Color(0xFFEEEEEE),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              gradient: LinearGradient(
                colors: const [
                  Colors.transparent,
                  Colors.white,
                  Colors.transparent
                ],
                stops: const [0.7, 0.3, 0.7],
                begin: Alignment(controller.value - 1, 0),
                end: Alignment(controller.value + 1, 0),
              ),
            ),
          ),
        );
      },
    );
  }
}
