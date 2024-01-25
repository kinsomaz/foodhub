import 'package:flutter/material.dart';

Widget buildFoodCategoryLoadingState(double screenHeight, double screenWidth) {
  return Container(
    height: screenHeight * 0.14,
    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(6, (index) {
          return _buildListItem(screenHeight, screenWidth);
        }),
      ),
    ),
  );
}

Widget _buildListItem(double screenHeight, double screenWidth) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: screenWidth * 0.16,
      height: screenHeight * 0.14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
          color: const Color(0xFFEEEEEE),
        ),
        color: const Color(0xFFFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    ),
  );
}
