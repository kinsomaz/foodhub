import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/views/restaurant/featured_item_list_view.dart';
import 'package:foodhub/views/menu/menu_item.dart';

typedef SearchedMenuItemCallback = void Function(MenuItem menuItem);

typedef IsSearchedFoodItemFavouriteCallback = Stream<bool> Function(
  MenuItem menuItem,
);

class SearchMenuItemListView extends StatefulWidget {
  final List<MenuItem> menuItems;
  final SearchedMenuItemCallback onTap;
  final SearchedMenuItemCallback addToFavourite;
  final IsSearchedFoodItemFavouriteCallback isFavourite;
  const SearchMenuItemListView({
    super.key,
    required this.menuItems,
    required this.onTap,
    required this.addToFavourite,
    required this.isFavourite,
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
          (menuItem) => GestureDetector(
            onTap: () {
              widget.onTap(menuItem);
            },
            child: Container(
              height: screenHeight * 0.27,
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
                  Stack(
                    children: [
                      CachedNetworkImage(
                          imageUrl: imageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                                height: screenHeight * 0.19,
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
                          errorWidget: (context, url, error) {
                            return Container(
                              height: screenHeight * 0.15,
                              width: screenWidth * 0.41,
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(10),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                            );
                          }),
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
                      left: screenWidth * 0.02,
                      right: screenWidth * 0.015,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                  ),
                  SizedBox(
                    height: screenHeight * 0.001,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.02,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            menuItem.ingredients,
                            style: TextStyle(
                              fontSize: screenWidth * 0.036,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'HelveticaNeue',
                              color: const Color(0xFF7E8392),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
