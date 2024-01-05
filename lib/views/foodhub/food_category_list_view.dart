import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/views/foodhub/food_category.dart';

typedef FoodCategoryCallback = void Function(FoodCategory foodCategory);
typedef FoodCategorySecondCallback = void Function();

class FoodCategoryListView extends StatefulWidget {
  final Iterable<FoodCategory> foodCategories;
  final FoodCategoryCallback onTap;
  final FoodCategorySecondCallback onSecondTap;

  const FoodCategoryListView({
    super.key,
    required this.foodCategories,
    required this.onTap,
    required this.onSecondTap,
  });

  @override
  State<FoodCategoryListView> createState() => _FoodCategoryListViewState();
}

class _FoodCategoryListViewState extends State<FoodCategoryListView> {
  int selectedIdx = -1;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: widget.foodCategories.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final foodCategory = widget.foodCategories.elementAt(index);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (selectedIdx == index) {
                selectedIdx = -1;
                widget.onSecondTap();
              } else {
                selectedIdx = index;
                widget.onTap(foodCategory);
              }
            });
          },
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.025),
            child: Container(
              width: 54,
              height: 100,
              decoration: BoxDecoration(
                color: index == selectedIdx
                    ? const Color(0xFFFE724C)
                    : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(25.0),
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  CachedNetworkImage(
                    imageUrl: foodCategory.imageUrl,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundImage: imageProvider,
                      backgroundColor: const Color(0xFFFFFFFF),
                      radius: 23,
                    ),
                    placeholder: (context, url) => CircleAvatar(
                      backgroundColor: Colors.black.withAlpha(10),
                      radius: 23,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    foodCategory.name,
                    style: TextStyle(
                      color: index == selectedIdx
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFF67666D),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
