import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/services/bloc/food_hub_bloc.dart';
import 'package:foodhub/services/bloc/food_hub_event.dart';
import 'package:foodhub/utilities/widget/dot_indicator.dart';
import 'package:foodhub/views/foodhub/onboard_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Expanded(
              flex: 14,
              child: PageView.builder(
                itemCount: demoData.length,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemBuilder: (context, index) => OnboardContent(
                  illustration: demoData[index]["illustration"],
                  title: demoData[index]["title"],
                  text: demoData[index]["text"],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                demoData.length,
                (index) => DotIndicator(isActive: index == currentPage),
              ),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xFFFE724C),
                  padding: const EdgeInsets.all(16.0),
                ),
                onPressed: () {
                  context.read<FoodHubBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                },
                child: const Icon(
                  Icons.arrow_forward,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// Demo data for our Onboarding screen
List<Map<String, dynamic>> demoData = [
  {
    "illustration": 'assets/Illustrations_1.svg',
    "title": "Browse your menu and order directly",
    "text":
        "Our app can send you everywhere, even \n space. For only \$2.99 per month",
  },
  {
    "illustration": "assets/Illustrations_2.svg",
    "title": "Even to space with us! Together",
    "text":
        "Our app can send you everywhere, even \n space. For only \$2.99 per month",
  },
  {
    "illustration": "assets/Illustrations_3.svg",
    "title": "Pickup delivery at your door",
    "text":
        "Easily find your type of food craving and\nyou’ll get delivery in wide range.",
  },
];
