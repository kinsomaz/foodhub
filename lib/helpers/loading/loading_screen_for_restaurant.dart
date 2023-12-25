import 'package:flutter/material.dart';

Widget buildRestaurantLoadingState(double screenHeight, double screenWidth) {
  return Container(
    height: screenHeight * 0.315,
    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(2, (index) {
          return _buildRestaurantListItem(screenHeight, screenWidth);
        }),
      ),
    ),
  );
}

Widget _buildRestaurantListItem(double screenHeight, double screenWidth) {
  return Padding(
    padding:
        EdgeInsets.only(left: screenWidth * 0.025, right: screenWidth * 0.025),
    child: Container(
      height: screenHeight * 0.30,
      width: screenWidth * 0.7,
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
        children: [
          Container(
            height: screenHeight * 0.185,
            width: screenWidth * 0.7,
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(10),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.007),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.03,
                  right: screenWidth * 0.015,
                ),
                child: Container(
                  width: 100,
                  height: 15,
                  color: Colors.black.withAlpha(10),
                ),
              ),
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(10),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.03,
                  right: screenWidth * 0.015,
                ),
                child: Container(
                  width: 80,
                  height: 13,
                  color: Colors.black.withAlpha(10),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.02,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.03,
                  right: screenWidth * 0.015,
                ),
                child: Container(
                  width: 80,
                  height: 13,
                  color: Colors.black.withAlpha(10),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
