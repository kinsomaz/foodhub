import 'package:flutter/material.dart';
import 'package:foodhub/icons/custom_search_switch_icon.dart';
import 'package:foodhub/routes/menu_item_details_route.dart';
import 'package:foodhub/routes/restaurant_profile_route.dart';
import 'package:foodhub/services/auth/firebase_auth_provider.dart';
import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
import 'package:foodhub/views/foodhub/menu_item.dart';
import 'package:foodhub/views/foodhub/restaurant.dart';
import 'package:foodhub/views/foodhub/search_menu_item_list_view.dart';
import 'package:foodhub/views/foodhub/search_restaurant_list_view.dart';
import 'package:rxdart/rxdart.dart';

class SearchFoodScreen extends StatefulWidget {
  const SearchFoodScreen({super.key});

  @override
  State<SearchFoodScreen> createState() => _SearchFoodScreenState();
}

class _SearchFoodScreenState extends State<SearchFoodScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final FirebaseCloudDatabase _cloudServices;
  late final FirebaseAuthProvider _authProvider;
  late final TabController _tabController;
  late final BehaviorSubject<String> _textSubject;
  final FocusNode _focusNodeSearch = FocusNode();
  GlobalKey foodItemKey = GlobalKey();
  GlobalKey restaurantKey = GlobalKey();
  GlobalKey? selectedKey;

  @override
  void initState() {
    _searchController = TextEditingController();
    _cloudServices = FirebaseCloudDatabase();
    _authProvider = FirebaseAuthProvider();
    _tabController = TabController(length: 2, vsync: this);
    _textSubject = BehaviorSubject<String>.seeded('_');

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _textSubject.close();
    _focusNodeSearch.dispose();
    super.dispose();
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
          'Search Food',
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
          Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xFFFCFCFD),
                    border: Border.all(
                      color: _focusNodeSearch.hasFocus
                          ? const Color(0xFFFE724C)
                          : const Color(0xFFEFEFEF),
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNodeSearch,
                    keyboardType: TextInputType.text,
                    enableSuggestions: false,
                    autocorrect: false,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: const InputDecoration(
                      hintText: 'Find for food or restaurant',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF9AA0B4),
                      ),
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                    onTapOutside: (event) {
                      _focusNodeSearch.unfocus();
                    },
                    onChanged: (value) {
                      _textSubject.add(value);
                    },
                    cursorColor: const Color(0xFFFE724C),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.04,
                ),
                Container(
                  width: screenWidth * 0.1,
                  height: screenHeight * 0.05,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: CustomSearchSwitchIcon(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.025,
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
                      'Food Item',
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
                      'Restaurant',
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
                      stream: _textSubject
                          .debounceTime(const Duration(milliseconds: 300))
                          .switchMap(
                            (searchText) => _cloudServices.searchForFoodItem(
                              searchTextStream: _textSubject.stream,
                            ),
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
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SearchMenuItemListView(
                                        menuItems: data,
                                        onTap: (MenuItem menuItem) {
                                          Navigator.of(context).push(
                                            menuItemDetailsRoute(
                                                arguments: [menuItem]),
                                          );
                                        },
                                        addToFavourite: (MenuItem menuItem) {
                                          _cloudServices
                                              .addOrRemoveFavouriteFoodItem(
                                            menuItem: menuItem,
                                            userId:
                                                _authProvider.currentUser!.uid,
                                          );
                                        },
                                        isFavourite: (MenuItem menuItem) {
                                          return _cloudServices
                                              .isFoodItemFavourite(
                                            menuItem: menuItem,
                                            userId:
                                                _authProvider.currentUser!.uid,
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.01,
                                      ),
                                    ],
                                  ),
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
                      stream: _textSubject
                          .debounceTime(const Duration(milliseconds: 300))
                          .switchMap(
                            (searchText) => _cloudServices.searchForRestaurant(
                              searchTextStream: _textSubject.stream,
                            ),
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
                              final data = snapshot.data as List<Restaurant>;
                              return Container(
                                margin: EdgeInsets.only(
                                  left: screenWidth * 0.025,
                                  right: screenWidth * 0.025,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SearchRestaurantListView(
                                        restaurants: data,
                                        onTap: (restaurant) {
                                          Navigator.of(context).push(
                                              restaurantProfileRoute(
                                                  arguments: [restaurant]));
                                        },
                                        addToFavourite:
                                            (Restaurant restaurant) {
                                          _cloudServices
                                              .addOrRemoveFavouriteRestaurant(
                                            restaurant: restaurant,
                                            userId:
                                                _authProvider.currentUser!.uid,
                                          );
                                        },
                                        isFavourite: (Restaurant restaurant) {
                                          return _cloudServices
                                              .isRestaurantFavourite(
                                            restaurant: restaurant,
                                            userId:
                                                _authProvider.currentUser!.uid,
                                          );
                                        },
                                        getRestaurantFee:
                                            (String restaurantName) {
                                          return _cloudServices
                                              .getRestaurantFee(
                                            restaurantName: restaurantName,
                                            userId:
                                                _authProvider.currentUser!.uid,
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.01,
                                      ),
                                    ],
                                  ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
