import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/views/menu/menu_item.dart';

typedef FavouriteItemCallback = void Function(MenuItem menuItem);

const imageUrl =
    'https://firebasestorage.googleapis.com/v0/b/foodhub-363a9.appspot.com/o/restaurant%2FChicken%20Republic.jpg?alt=media&token=b85b8617-d655-4a2e-ab77-6d6cb4eed204';

class FavouriteItemListView extends StatefulWidget {
  final Iterable<MenuItem> menuitems;
  final FavouriteItemCallback onTap;

  const FavouriteItemListView({
    super.key,
    required this.menuitems,
    required this.onTap,
  });

  @override
  State<FavouriteItemListView> createState() => _FavouriteItemListViewState();
}

class _FavouriteItemListViewState extends State<FavouriteItemListView> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ListView.builder(
      itemCount: widget.menuitems.length,
      scrollDirection: Axis.vertical,
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
              height: screenHeight * 0.27,
              width: screenWidth,
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
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          height: screenHeight * 0.185,
                          width: screenWidth,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: Image(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          height: screenHeight * 0.185,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(10),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 10,
                        child: Container(
                          height: 27,
                          width: 53,
                          decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Color(0xFFFFFFFF)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.attach_money,
                                size: 17,
                                color: Color(0xFFFE724C),
                              ),
                              Text(
                                menuItem.price,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 4,
                            right: 4,
                            top: 5,
                            bottom: 4,
                          ),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFE724C),
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: Color(0xFFFFFFFF),
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
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
                          fontSize: 14,
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
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        menuItem.ingredients,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SofiaPro',
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
