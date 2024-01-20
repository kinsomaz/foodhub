import 'package:flutter/material.dart';
import 'package:foodhub/routes/menu_item_details_route.dart';
import 'package:foodhub/routes/restaurant_profile_route.dart';
import 'package:foodhub/services/auth/firebase_auth_provider.dart';
import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
import 'package:foodhub/views/foodhub/favourite_item_list_view.dart';
import 'package:foodhub/views/foodhub/favourite_restaurant_list_view.dart';
import 'package:foodhub/views/foodhub/menu_item.dart';
import 'package:foodhub/views/foodhub/restaurant.dart';

class FavouriteFoodItemView extends StatefulWidget {
  const FavouriteFoodItemView({super.key});

  @override
  State<FavouriteFoodItemView> createState() => _FavouriteFoodItemViewState();
}

class _FavouriteFoodItemViewState extends State<FavouriteFoodItemView>
    with SingleTickerProviderStateMixin {
  late final FirebaseCloudDatabase _cloudServices;
  late final FirebaseAuthProvider _authProvider;
  late final TabController _tabController;
  GlobalKey foodItemKey = GlobalKey();
  GlobalKey restaurantKey = GlobalKey();
  GlobalKey? selectedKey;

  @override
  void initState() {
    _cloudServices = FirebaseCloudDatabase();
    _authProvider = FirebaseAuthProvider();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(
            right: 9,
            left: 16,
            top: 10,
            bottom: 16,
          ),
          child: Container(
            height: screenHeight * 0.04,
            width: screenWidth * 0.08,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 1.5,
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
        title: const Text(
          'Favourites',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color(0xFF111719)),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: const Color(0xFFEEEEEE),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xFFFE724C),
              ),
              tabs: [
                Tab(
                  child: Container(
                    height: 44,
                    key: foodItemKey,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      'Food Items',
                      style: TextStyle(
                        color: _tabController.index == 0
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF67666D),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    height: 44,
                    key: restaurantKey,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      'Restaurants',
                      style: TextStyle(
                        color: _tabController.index == 1
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF67666D),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
              onTap: (index) {
                setState(() {
                  selectedKey = index == 0 ? foodItemKey : restaurantKey;
                });
                _tabController.animateTo(index);
              },
            ),
          ),
          SizedBox(
            height: screenHeight * 0.025,
          ),
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [
              Builder(
                builder: (context) {
                  return StreamBuilder(
                    stream: _cloudServices.favouriteMenuItem(
                      userId: _authProvider.currentUser!.uid,
                    ),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final data = snapshot.data as List<MenuItem>;
                            return Container(
                              margin: EdgeInsets.only(
                                left: screenWidth * 0.025,
                                right: screenWidth * 0.025,
                              ),
                              child: FavouriteItemListView(
                                menuitems: data,
                                onTap: (menuItem) {
                                  Navigator.of(context).push(
                                      menuItemDetailsRoute(
                                          arguments: [menuItem]));
                                },
                              ),
                            );
                          } else {
                            return const Center(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        default:
                          return const Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(),
                            ),
                          );
                      }
                    },
                  );
                },
              ),
              Builder(
                builder: (context) {
                  return StreamBuilder(
                    stream: _cloudServices.favouriteRestaurants(
                        userId: _authProvider.currentUser!.uid),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final data = snapshot.data as List<Restaurant>;
                            return Container(
                              margin: EdgeInsets.only(
                                left: screenWidth * 0.025,
                                right: screenWidth * 0.025,
                              ),
                              child: FavouriteRestaurantListView(
                                restaurants: data,
                                onTap: (restaurant) {
                                  Navigator.of(context).push(
                                    restaurantProfileRoute(
                                        arguments: [restaurant]),
                                  );
                                },
                                getRestaurantFee: (String restaurantName) {
                                  return _cloudServices.getRestaurantFee(
                                    restaurantName: restaurantName,
                                    userId: _authProvider.currentUser!.uid,
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Center(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        default:
                          return const Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(),
                            ),
                          );
                      }
                    },
                  );
                },
              )
            ],
          ))
        ],
      ),
    );
  }
}
