import 'package:flutter/material.dart';

class CustomDropDownItem extends StatelessWidget {
  final String label;
  final IconData icon;

  const CustomDropDownItem({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      titleTextStyle: TextStyle(
        fontSize: screenWidth * 0.05,
        color: const Color(0xFF111719),
        fontWeight: FontWeight.w400,
        fontFamily: 'SofiaPro',
      ),
    );
  }
}
