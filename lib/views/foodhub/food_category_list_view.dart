import 'package:flutter/material.dart';
import 'package:foodhub/views/foodhub/food_caregory.dart';

typedef FoodCategoryCallback = void Function(FoodCategory catogoryName);

class FoodCategoryListView extends StatefulWidget {
  final Iterable<FoodCategory> foodCategories;
  final FoodCategoryCallback onTap;

  const FoodCategoryListView({
    super.key,
    required this.foodCategories,
    required this.onTap,
  });

  @override
  State<FoodCategoryListView> createState() => _FoodCategoryListViewState();
}

class _FoodCategoryListViewState extends State<FoodCategoryListView> {
  int selectedIdx = -1;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.foodCategories.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final foodCategory = widget.foodCategories.elementAt(index);
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIdx = index;
            });
            widget.onTap(foodCategory);
          },
          child: Container(
            width: 56,
            height: 98,
            margin: const EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
              color: index == selectedIdx
                  ? const Color(0xFFFE724C)
                  : const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15,
                  child: Placeholder(),
                ),
                Text(foodCategory.name),
              ],
            ),
          ),
        );
      },
    );
  }
}
