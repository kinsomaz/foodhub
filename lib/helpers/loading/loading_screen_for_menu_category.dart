import 'package:flutter/material.dart';

Widget buildMenuCategoryLoadingState(double screenHeight, double screenWidth) {
  return Container(
    height: 50,
    margin: EdgeInsets.only(
      left: screenWidth * 0.025,
      right: screenWidth * 0.025,
      bottom: screenWidth * 0.005,
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(4, (index) {
          return _buildListItem(screenHeight, screenWidth);
        }),
      ),
    ),
  );
}

Widget _buildListItem(double screenHeight, double screenWidth) {
  return Padding(
    padding: EdgeInsets.all(screenWidth * 0.025),
    child: Container(
      height: 50,
      width: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.black.withAlpha(5),
        border: Border.all(
          color: Colors.black.withAlpha(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    ),
  );
}
