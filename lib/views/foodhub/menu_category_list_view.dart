import 'package:flutter/material.dart';
import 'package:foodhub/views/foodhub/menu_category.dart';

typedef MenuCategoryCallback = void Function(MenuCategory menuCategory);

typedef MenuCategorySecondCallback = void Function();

class MenuCategoryListView extends StatefulWidget {
  final List<MenuCategory> categories;
  final MenuCategoryCallback onTap;

  const MenuCategoryListView({
    super.key,
    required this.categories,
    required this.onTap,
  });

  @override
  State<MenuCategoryListView> createState() => _MenuCategoryListViewState();
}

class _MenuCategoryListViewState extends State<MenuCategoryListView> {
  int selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: widget.categories.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final category = widget.categories.elementAt(index);
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIdx = index;
              widget.onTap(category);
            });
          },
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.025),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              constraints: const BoxConstraints(
                minWidth: 50,
              ),
              decoration: BoxDecoration(
                color: index == selectedIdx
                    ? const Color(0xFFFE724C)
                    : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                category.category,
                style: TextStyle(
                  color: index == selectedIdx
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFF67666D),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
