import 'package:flutter/material.dart';

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
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_mall),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.alarm),
          label: '',
        ),
      ],
    );
  }
}
