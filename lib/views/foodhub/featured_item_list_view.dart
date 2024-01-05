import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/views/foodhub/menu_item.dart';

typedef FeaturedItemCallback = void Function(MenuItem menuItem);

const imageUrl =
    'https://firebasestorage.googleapis.com/v0/b/foodhub-363a9.appspot.com/o/restaurant%2FChicken%20Republic.jpg?alt=media&token=b85b8617-d655-4a2e-ab77-6d6cb4eed204';

class FeaturedItemListView extends StatefulWidget {
  final Iterable<MenuItem> menuitems;
  final FeaturedItemCallback onTap;

  const FeaturedItemListView({
    super.key,
    required this.menuitems,
    required this.onTap,
  });

  @override
  State<FeaturedItemListView> createState() => _FeaturedItemListViewState();
}

class _FeaturedItemListViewState extends State<FeaturedItemListView> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ListView.builder(
      itemCount: widget.menuitems.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final menuItem = widget.menuitems.elementAt(index);
        return GestureDetector(
          onTap: () {
            widget.onTap(menuItem);
          },
          child: Padding(
            padding: EdgeInsets.all(
              screenWidth * 0.025,
            ),
            child: Container(
              height: screenHeight * 0.25,
              width: screenWidth * 0.7,
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
                      height: screenHeight * 0.185,
                      width: screenWidth * 0.7,
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
                      height: screenHeight * 0.185,
                      width: screenWidth * 0.7,
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
          ),
        );
      },
    );
  }
}
