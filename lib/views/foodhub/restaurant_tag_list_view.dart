import 'package:flutter/material.dart';

class RestaurantTagListView extends StatelessWidget {
  final List<String> tags;
  const RestaurantTagListView({
    super.key,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: tags.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final tag = tags.elementAt(index);
        return Container(
          margin: EdgeInsets.only(
            left: screenWidth * 0.02,
          ),
          padding: EdgeInsets.only(
            left: screenWidth * 0.015,
            right: screenWidth * 0.015,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontFamily: 'SofiaPro',
                color: Color(0xFF8A8E9B),
              ),
            ),
          ),
        );
      },
    );
  }
}
