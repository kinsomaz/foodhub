import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/views/foodhub/featured_item_list_view.dart';
import 'package:foodhub/views/foodhub/menu_item.dart';

typedef SearchMenuItemCallback = void Function(MenuItem menuItem);

class SearchMenuItemListView extends StatefulWidget {
  final List<MenuItem> menuItems;
  final SearchMenuItemCallback onTap;
  const SearchMenuItemListView({
    super.key,
    required this.menuItems,
    required this.onTap,
  });

  @override
  State<SearchMenuItemListView> createState() => _SearchMenuItemListViewState();
}

class _SearchMenuItemListViewState extends State<SearchMenuItemListView> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Wrap(
      spacing: screenWidth * 0.005,
      runSpacing: screenWidth * 0.05,
      alignment: WrapAlignment.spaceEvenly,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: screenWidth * 0.41,
            margin: EdgeInsets.only(left: screenWidth * 0.025),
            child: Text(
              'Found ${widget.menuItems.length} results',
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.w700,
                fontFamily: 'SofiaPro',
                color: const Color(0xFF111719),
              ),
            ),
          ),
        ),
        ...widget.menuItems.map(
          (menuItem) => Container(
            height: screenHeight * 0.22,
            width: screenWidth * 0.41,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(15),
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
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    height: screenHeight * 0.15,
                    width: screenWidth * 0.41,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    height: screenHeight * 0.15,
                    width: screenWidth * 0.41,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(10),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.007,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.03,
                    right: screenWidth * 0.015,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      menuItem.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SofiaPro',
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.001,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.03,
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'HelveticaNeue',
                        color: Color(0xFF7E8392),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
