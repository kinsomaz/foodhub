import 'package:flutter/material.dart';
import 'package:foodhub/utilities/animations/food_category_animation.dart';

Widget buildFoodCategoryLoadingState(
    double screenWidth, AnimationController waterFlowController) {
  return Container(
    height: 100,
    margin: EdgeInsets.only(left: screenWidth * 0.025),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(6, (index) {
          return FoodCategoryAnimation(
            controller: waterFlowController,
          );
        }),
      ),
    ),
  );
}
