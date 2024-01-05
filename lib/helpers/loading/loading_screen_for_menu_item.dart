import 'package:flutter/material.dart';

Widget buildMenuItemLoadingState(double screenHeight, double screenWidth) {
  return Container(
      margin: EdgeInsets.only(
        left: screenWidth * 0.025,
        right: screenWidth * 0.025,
        bottom: screenWidth * 0.005,
      ),
      child: Wrap(
        spacing: screenWidth * 0.05,
        runSpacing: screenWidth * 0.05,
        children: List.generate(8, (index) {
          return _buildListItem(screenHeight, screenWidth);
        }),
      ));
}

Widget _buildListItem(double screenHeight, double screenWidth) {
  return Container(
    height: screenHeight * 0.22,
    width: screenWidth * 0.41,
    decoration: BoxDecoration(
      color: const Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: const Color(0xFFEEEEEE)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: screenHeight * 0.15,
          width: screenWidth * 0.41,
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(10),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.007,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.03,
            right: screenWidth * 0.015,
          ),
          child: Container(
            width: 70,
            height: 14,
            color: Colors.black.withAlpha(10),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.007,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.03,
            right: screenWidth * 0.015,
          ),
          child: Container(
            width: 100,
            height: 12,
            color: Colors.black.withAlpha(10),
          ),
        ),
      ],
    ),
  );
}
