import 'package:flutter/material.dart';

Widget buildAddOnLoadingState(double screenHeight, double screenWidth) {
  return Container(
    constraints: const BoxConstraints(
      maxHeight: 130,
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: List.generate(3, (index) {
          return _buildListItem(screenHeight, screenWidth);
        }),
      ),
    ),
  );
}

Widget _buildListItem(double screenHeight, double screenWidth) {
  return Wrap(
    children: [
      Container(
        width: screenWidth,
        height: 43,
        padding: const EdgeInsets.only(
          left: 20,
          right: 25,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withAlpha(10),
                  ),
                  padding: const EdgeInsets.all(4.0),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  width: 100,
                  height: 16,
                  color: Colors.black.withAlpha(10),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 30,
                  height: 14,
                  color: Colors.black.withAlpha(10),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withAlpha(10),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ],
  );
}
