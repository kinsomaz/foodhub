import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/views/menu/menu_item.dart';

typedef FeaturedItemCallback = void Function(MenuItem menuItem);
typedef IsFoodItemFavouriteCallback = Stream<bool> Function(
  MenuItem menuItem,
);

const imageUrl =
    'https://firebasestorage.googleapis.com/v0/b/foodhub-363a9.appspot.com/o/restaurant%2FChicken%20Republic.jpg?alt=media&token=b85b8617-d655-4a2e-ab77-6d6cb4eed204';

class FeaturedItemListView extends StatefulWidget {
  final Iterable<MenuItem> menuitems;
  final FeaturedItemCallback onTap;
  final FeaturedItemCallback addToFavourite;
  final IsFoodItemFavouriteCallback isFavourite;

  const FeaturedItemListView({
    super.key,
    required this.menuitems,
    required this.onTap,
    required this.addToFavourite,
    required this.isFavourite,
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
              height: screenHeight * 0.27,
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
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          height: screenHeight * 0.185,
                          width: screenWidth * 0.7,
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
                          width: screenWidth * 0.7,
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(10),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          return Container(
                            height: screenHeight * 0.185,
                            width: screenWidth * 0.7,
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(10),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: const Text('failed to load image'),
                          );
                        },
                      ),
                      Positioned(
                        top: 10,
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
                        top: 10,
                        right: 10,
                        child: StreamBuilder(
                            stream: widget.isFavourite(menuItem),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case (ConnectionState.waiting):
                                case (ConnectionState.active):
                                  if (snapshot.hasData) {
                                    if (snapshot.data == true) {
                                      return GestureDetector(
                                        onTap: () {
                                          widget.addToFavourite(menuItem);
                                        },
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
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          widget.addToFavourite(menuItem);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            left: 4,
                                            right: 4,
                                            top: 5,
                                            bottom: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xFFFFFFFF)
                                                .withAlpha(60),
                                          ),
                                          child: const Icon(
                                            Icons.favorite_rounded,
                                            color: Color(0xFFFFFFFF),
                                            size: 18,
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        widget.addToFavourite(menuItem);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 4,
                                          right: 4,
                                          top: 5,
                                          bottom: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFFFFFFFF)
                                              .withAlpha(60),
                                        ),
                                        child: const Icon(
                                          Icons.favorite_rounded,
                                          color: Color(0xFFFFFFFF),
                                          size: 18,
                                        ),
                                      ),
                                    );
                                  }
                                default:
                                  return GestureDetector(
                                    onTap: () {
                                      widget.addToFavourite(menuItem);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        left: 4,
                                        right: 4,
                                        top: 5,
                                        bottom: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFFFFFFF)
                                            .withAlpha(60),
                                      ),
                                      child: const Icon(
                                        Icons.favorite_rounded,
                                        color: Color(0xFFFFFFFF),
                                        size: 18,
                                      ),
                                    ),
                                  );
                              }
                            }),
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
                        style: TextStyle(
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SofiaPro',
                          color: const Color(0xFF000000),
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
                        style: TextStyle(
                          fontSize: screenWidth * 0.036,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SofiaPro',
                          color: const Color(0xFF7E8392),
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
