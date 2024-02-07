import 'package:flutter/material.dart';

Widget buildCartItemLoadingState(double screenHeight, double screenWidth) {
  return Container(
      margin: EdgeInsets.only(
        left: screenWidth * 0.025,
        right: screenWidth * 0.025,
        bottom: screenWidth * 0.005,
      ),
      child: Wrap(
        spacing: screenWidth * 0.05,
        runSpacing: screenWidth * 0.05,
        children: List.generate(2, (index) {
          return _buildListItem(screenHeight, screenWidth);
        }),
      ));
}

Widget _buildListItem(double screenHeight, double screenWidth) {
  return Padding(
    padding: EdgeInsets.only(
      right: screenWidth * 0.04,
      left: screenWidth * 0.04,
      bottom: 10,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: screenHeight * 0.08,
              width: screenWidth * 0.17,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(10),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
            const SizedBox(
              width: 13,
            ),
            SizedBox(
              width: screenWidth * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                    width: screenWidth * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(10),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                    width: screenWidth * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(10),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                    width: screenWidth * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(10),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: screenHeight * 0.08,
        ),
      ],
    ),
  );
}
