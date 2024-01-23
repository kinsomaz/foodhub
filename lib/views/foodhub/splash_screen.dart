import 'package:flutter/material.dart';
import 'package:foodhub/icons/custom_food_hub_icon.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFE724C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomFoodHubIcon(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'FOOD',
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Phosphate',
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFFFFFFF)),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'HUB',
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Phosphate',
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFFFFFFF).withOpacity(0.6)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
