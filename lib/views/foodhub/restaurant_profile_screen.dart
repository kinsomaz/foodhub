import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/helpers/loading/loading_screen_for_featured_item.dart';
import 'package:foodhub/helpers/loading/loading_screen_for_menu_category.dart';
import 'package:foodhub/helpers/loading/loading_screen_for_menu_item.dart';
import 'package:foodhub/icons/custom_delivery_clock_icon.dart';
import 'package:foodhub/icons/custom_delivery_icon.dart';
import 'package:foodhub/services/auth/firebase_auth_provider.dart';
import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
import 'package:foodhub/views/foodhub/featured_item_list_view.dart';
import 'package:foodhub/views/foodhub/menu_category.dart';
import 'package:foodhub/views/foodhub/menu_category_list_view.dart';
import 'package:foodhub/views/foodhub/menu_item.dart';
import 'package:foodhub/views/foodhub/menu_item_list_view.dart';
import 'package:foodhub/views/foodhub/restaurant.dart';

class RestaurantProfileScreen extends StatefulWidget {
  const RestaurantProfileScreen({
    super.key,
  });

  @override
  State<RestaurantProfileScreen> createState() =>
      _RestaurantProfileScreenState();
}

class _RestaurantProfileScreenState extends State<RestaurantProfileScreen> {
  late final FirebaseCloudDatabase _cloudServices;
  late final FirebaseAuthProvider _authProvider;
  late final StreamController<String?> _menuCategoryNameController;

  @override
  void initState() {
    _cloudServices = FirebaseCloudDatabase();
    _authProvider = FirebaseAuthProvider();
    _menuCategoryNameController = StreamController<String?>.broadcast(
      onListen: () {
        _menuCategoryNameController.sink.add(null);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _menuCategoryNameController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final restaurant = arguments[0] as Restaurant;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CachedNetworkImage(
                      imageUrl: restaurant.imageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        height: screenHeight * 0.185,
                        width: screenWidth,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                        ),
                        margin: const EdgeInsets.only(
                          top: 30,
                          bottom: 40,
                        ),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        )),
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
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(10),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: restaurant.logo,
                            imageBuilder: (context, imageProvider) => Container(
                              height: 70,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 221, 192, 47),
                              ),
                              child: Image(
                                image: imageProvider,
                                fit: BoxFit.contain,
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              height: 70,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withAlpha(10),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 15,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.check_circle,
                              color: restaurant.isVerified
                                  ? const Color(0xFF029094)
                                  : const Color(0xFFD3D1D8),
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 40,
                  right: 27,
                  child: StreamBuilder(
                      stream: _cloudServices.isRestaurantFavourite(
                          restaurant: restaurant,
                          userId: _authProvider.currentUser!.uid),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case (ConnectionState.waiting):
                          case (ConnectionState.active):
                            if (snapshot.hasData) {
                              if (snapshot.data == true) {
                                return GestureDetector(
                                  onTap: () {
                                    _cloudServices
                                        .addOrRemoveFavouriteRestaurant(
                                            restaurant: restaurant,
                                            userId:
                                                _authProvider.currentUser!.uid);
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
                                    _cloudServices
                                        .addOrRemoveFavouriteRestaurant(
                                            restaurant: restaurant,
                                            userId:
                                                _authProvider.currentUser!.uid);
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
                                      color:
                                          const Color(0xFFFFFFFF).withAlpha(60),
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
                                  _cloudServices.addOrRemoveFavouriteRestaurant(
                                      restaurant: restaurant,
                                      userId: _authProvider.currentUser!.uid);
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
                                    color:
                                        const Color(0xFFFFFFFF).withAlpha(60),
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
                                _cloudServices.addOrRemoveFavouriteRestaurant(
                                    restaurant: restaurant,
                                    userId: _authProvider.currentUser!.uid);
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
                                  color: const Color(0xFFFFFFFF).withAlpha(60),
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
                Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.06,
                    left: screenWidth * 0.07,
                  ),
                  child: Container(
                    height: screenHeight * 0.041,
                    width: screenWidth * 0.08,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          )
                        ]),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.015,
                      ),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: screenWidth * 0.05,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              restaurant.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: 'SofiaPro',
                color: Color(0xFF111719),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.007,
            ),
            Wrap(
              spacing: screenWidth * 0.02,
              children: restaurant.tags.map((tag) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.015,
                    vertical: 3.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SofiaPro',
                      color: Color(0xFF8A8E9B),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: screenHeight * 0.007,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.03,
                    right: screenWidth * 0.02,
                  ),
                  child: const CustomDeliveryIcon(),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: screenWidth * 0.02,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      restaurant.deliveryFee,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'HelveticaNeue',
                        color: Color(0xFF7E8392),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.015,
                    right: screenWidth * 0.01,
                  ),
                  child: const CustomDeliveryClockIcon(),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: screenWidth * 0.015,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      restaurant.deliveryTime,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'HelveticaNeue',
                        color: Color(0xFF7E8392),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.04,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.05,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: screenWidth * 0.67,
                  child: const Text(
                    'Featured items',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SofiaPro',
                      color: Color(0xFF323643),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.005,
            ),
            StreamBuilder(
              stream: _cloudServices.featuredMenuItem(
                restaurantName: restaurant.name,
              ),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final menus = snapshot.data as List<MenuItem>;
                      return Container(
                        height: screenHeight * 0.3,
                        margin: EdgeInsets.only(
                          left: screenWidth * 0.025,
                          right: screenWidth * 0.025,
                        ),
                        child: FeaturedItemListView(
                          menuitems: menus,
                          onTap: (menuItem) {},
                          addToFavourite: (MenuItem menuItem) {
                            _cloudServices.addOrRemoveFavouriteFoodItem(
                              menuItem: menuItem,
                              userId: _authProvider.currentUser!.uid,
                            );
                          },
                          isFavourite: (MenuItem menuItem) {
                            return _cloudServices.isFoodItemFavourite(
                              menuItem: menuItem,
                              userId: _authProvider.currentUser!.uid,
                            );
                          },
                        ),
                      );
                    } else {
                      return buildFeaturedItemLoadingState(
                          screenHeight, screenWidth);
                    }
                  default:
                    return buildFeaturedItemLoadingState(
                        screenHeight, screenWidth);
                }
              },
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            StreamBuilder(
              stream:
                  _cloudServices.menuCategory(restaurantName: restaurant.name),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return buildMenuCategoryLoadingState(
                        screenHeight, screenWidth);
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final categories = snapshot.data as List<MenuCategory>;
                      return Container(
                        height: 50,
                        margin: EdgeInsets.only(
                          left: screenWidth * 0.025,
                          right: screenWidth * 0.025,
                        ),
                        child: MenuCategoryListView(
                          categories: categories,
                          onTap: (menuCategory) {
                            _menuCategoryNameController
                                .add(menuCategory.category);
                          },
                        ),
                      );
                    } else {
                      return buildMenuCategoryLoadingState(
                          screenHeight, screenWidth);
                    }
                  default:
                    return buildMenuCategoryLoadingState(
                        screenHeight, screenWidth);
                }
              },
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            StreamBuilder(
              stream: _cloudServices.menuItemsStream(
                restaurantName: restaurant.name,
                menuCategoryNameStream: _menuCategoryNameController.stream,
              ),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return buildMenuItemLoadingState(
                      screenHeight,
                      screenWidth,
                    );
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final menuItems = snapshot.data as List<MenuItem>;
                      return Container(
                        margin: EdgeInsets.only(
                          left: screenWidth * 0.025,
                          right: screenWidth * 0.025,
                        ),
                        child: MenuItemListView(
                          menuItems: menuItems,
                          onTap: (menuItem) {},
                          addToFavourite: (MenuItem menuItem) {
                            _cloudServices.addOrRemoveFavouriteFoodItem(
                              menuItem: menuItem,
                              userId: _authProvider.currentUser!.uid,
                            );
                          },
                          isFavourite: (MenuItem menuItem) {
                            return _cloudServices.isFoodItemFavourite(
                              menuItem: menuItem,
                              userId: _authProvider.currentUser!.uid,
                            );
                          },
                        ),
                      );
                    } else {
                      return buildMenuItemLoadingState(
                          screenHeight, screenWidth);
                    }
                  default:
                    return buildMenuItemLoadingState(
                      screenHeight,
                      screenWidth,
                    );
                }
              },
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
          ],
        ),
      ),
    );
  }
}
