import 'package:flutter/material.dart';
import 'package:foodhub/icons/custom_cart_icon.dart';
import 'package:foodhub/icons/custom_home_icon.dart';
import 'package:foodhub/icons/custom_order_history_icon.dart';
import 'package:foodhub/icons/custom_tracking_icon.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const MyBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedIconTheme: const IconThemeData(
        color: Color(0xFFFE724C),
        size: 24.0,
      ),
      unselectedIconTheme: const IconThemeData(
        color: Color(0xFFD3D1D8),
        size: 22.0,
      ),
      selectedFontSize: 0.0,
      unselectedFontSize: 0.0,
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: CustomHomeIcon(),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: CustomTrackingIcon(),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: CustomCartIcon(),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: CustomOrderHistoryIcon(),
          label: '',
        ),
      ],
    );
  }
}
