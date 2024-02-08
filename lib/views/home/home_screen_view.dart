import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/helpers/loading/loading_screen_for_food_category.dart';
import 'package:foodhub/helpers/loading/loading_screen_for_menu_item.dart';
import 'package:foodhub/helpers/loading/loading_screen_for_restaurant.dart';
import 'package:foodhub/helpers/loading/loading_screen_with_no_text.dart';
import 'package:foodhub/icons/custom_search_switch_icon.dart';
import 'package:foodhub/routes/cart_route.dart';
import 'package:foodhub/routes/favourite_route.dart';
import 'package:foodhub/routes/menu_item_details_route.dart';
import 'package:foodhub/routes/orders_route.dart';
import 'package:foodhub/routes/payment_method_route.dart';
import 'package:foodhub/routes/profile_route.dart';
import 'package:foodhub/routes/restaurant_profile_route.dart';
import 'package:foodhub/routes/search_food_route.dart';
import 'package:foodhub/routes/tracking_route.dart';
import 'package:foodhub/services/auth/firebase_auth_provider.dart';
import 'package:foodhub/services/bloc/food_hub_bloc.dart';
import 'package:foodhub/services/bloc/food_hub_event.dart';
import 'package:foodhub/services/cloud/database/cloud_profile.dart';
import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
import 'package:foodhub/utilities/dialogs/cart_dialog.dart';
import 'package:foodhub/utilities/dialogs/logout_dialog.dart';
import 'package:foodhub/utilities/widget/bottom_navigation_bar.dart';
import 'package:foodhub/views/home/food_category.dart';
import 'package:foodhub/views/home/food_category_list_view.dart';
import 'package:foodhub/views/menu/menu_item.dart';
import 'package:foodhub/views/home/popular_item_list_view.dart';
import 'package:foodhub/views/profile/profile_image.dart';
import 'package:foodhub/views/restaurant/restaurant.dart';
import 'package:foodhub/views/home/featured_restaurant_list_view.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final FirebaseCloudDatabase _cloudServices;
  late final FirebaseAuthProvider _authProvider;
  late final User? _user;
  late final StreamController<String> _foodCategoryNameController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _focusNodeSearch = FocusNode();
  late final List<dynamic> route;

  @override
  void initState() {
    _searchController = TextEditingController();
    _cloudServices = FirebaseCloudDatabase();
    _authProvider = FirebaseAuthProvider();
    _user = FirebaseAuthProvider().currentUser;
    _foodCategoryNameController = StreamController<String>.broadcast(
      onListen: () {
        _foodCategoryNameController.sink.add('all');
      },
    );
    route = [
      null,
      () => trackingRoute(),
      () {},
      () => favouriteRoute(),
      () => ordersRoute(),
    ];
    _focusNodeSearch.addListener(() {
      setState(() {});
    });
    super.initState();

    super.initState();
  }

  void _onSearchFieldFocus() {
    Navigator.of(context).push(searchFoodRoute());
  }

  Future<String?> _cartViewRouteProcessing() async {
    final cartItems = await _cloudServices.getAllCartItems(
      ownerUserId: _authProvider.currentUser!.uid,
    );
    for (var cartItem in cartItems) {
      if (cartItem['name'] != cartItems.first['name']) {
        return null;
      }
    }
    return cartItems.first['name'];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNodeSearch.dispose();
    _foodCategoryNameController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Food Hub'),
          centerTitle: true,
          actions: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: StreamBuilder(
                  stream: _cloudServices.userProfile(ownerUserId: _user!.uid),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final profiles = snapshot.data as List<CloudProfile>;
                          final userProfile = profiles[0];
                          if (userProfile.profileImageUrl.isEmpty) {
                            return Container();
                          } else {
                            return CachedNetworkImage(
                              imageUrl: userProfile.profileImageUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 32,
                                width: 33,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  child: Image(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                height: 32,
                                width: 33,
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(10),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            );
                          }
                        } else {
                          return Container();
                        }
                      default:
                        return Container();
                    }
                  },
                )),
          ],
        ),
        drawer: StreamBuilder(
          stream: _cloudServices.userProfile(ownerUserId: _user!.uid),
          builder: (drawerContext, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final profiles = snapshot.data as List<CloudProfile>;
                  final userProfile = profiles[0];
                  return Drawer(
                    width: screenWidth * 0.65,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFFFFF),
                      ),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          UserAccountsDrawerHeader(
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFFFFF),
                            ),
                            accountName: Text(
                              userProfile.userName,
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF000000),
                              ),
                            ),
                            accountEmail: Text(
                              userProfile.userEmail,
                              style: TextStyle(
                                fontSize: screenWidth * 0.036,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF9EA1B1),
                              ),
                            ),
                            currentAccountPicture: ProfileImage(
                              imageUrl: userProfile.profileImageUrl,
                              radius: screenWidth * 0.1,
                            ),
                          ),
                          ListTile(
                            leading: Image.asset(
                              "assets/my_order_icon.jpg",
                              width: screenWidth * 0.06,
                              height: screenHeight * 0.03,
                            ),
                            title: Text(
                              'My Orders',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {
                              scaffoldKey.currentState!.closeDrawer();
                              Navigator.of(context).push(ordersRoute());
                            },
                          ),
                          ListTile(
                            leading: Image.asset(
                              "assets/my_profile_icon.jpg",
                              width: screenWidth * 0.06,
                              height: screenHeight * 0.03,
                            ),
                            title: Text(
                              'My Profile',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {
                              scaffoldKey.currentState!.closeDrawer();
                              Navigator.of(context).push(profileRoute());
                            },
                          ),
                          ListTile(
                            leading: Image.asset(
                              "assets/location_icon.jpg",
                              width: screenWidth * 0.06,
                              height: screenHeight * 0.03,
                            ),
                            title: Text(
                              'Delivery Address',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Image.asset(
                              "assets/wallet_icon.jpg",
                              width: screenWidth * 0.06,
                              height: screenHeight * 0.03,
                            ),
                            title: Text(
                              'Payment Methods',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {
                              scaffoldKey.currentState!.closeDrawer();
                              Navigator.of(context).push(
                                paymentMethodRoute(),
                              );
                            },
                          ),
                          ListTile(
                            leading: Image.asset(
                              "assets/message_icon.jpg",
                              width: screenWidth * 0.06,
                              height: screenHeight * 0.03,
                            ),
                            title: Text(
                              'Contact Us',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Image.asset(
                              "assets/setting_icon.jpg",
                              width: screenWidth * 0.06,
                              height: screenHeight * 0.03,
                            ),
                            title: Text(
                              'Settings',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Image.asset(
                              "assets/helps_icon.jpg",
                              width: screenWidth * 0.06,
                              height: screenHeight * 0.025,
                            ),
                            title: Text(
                              'Helps & FAQS',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {},
                          ),
                          SizedBox(height: screenHeight * 0.07),
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenWidth * 0.04,
                              right: screenWidth * 0.22,
                            ),
                            child: TextButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFFFE724C),
                                  ),
                                  alignment: AlignmentDirectional.centerStart),
                              icon: CircleAvatar(
                                backgroundImage:
                                    const AssetImage("assets/log_out_icon.jpg"),
                                maxRadius: screenWidth * 0.038,
                              ),
                              label: Text(
                                'Log Out',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontFamily: 'SofiaPro',
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFFFFFFF),
                                ),
                              ),
                              onPressed: () async {
                                scaffoldKey.currentState!.closeDrawer();
                                final shouldLogout =
                                    await showLogOutDialog(drawerContext);
                                if (shouldLogout) {
                                  // ignore: use_build_context_synchronously
                                  context.read<FoodHubBloc>().add(
                                        const AuthEventLogOut(),
                                      );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.008,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    child: Text(
                      'What would you like to order',
                      style: TextStyle(
                        fontSize: screenWidth * 0.079,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SofiaPro',
                        color: const Color(0xFF111719),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Find for food or restaurant',
                          hintStyle: TextStyle(
                            fontSize: screenWidth * 0.042,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9AA0B4),
                          ),
                          prefixIcon: const Icon(Icons.search),
                          border: InputBorder.none,
                        ),
                        onTap: () {
                          _onSearchFieldFocus();
                        },
                        onTapOutside: (event) {
                          _focusNodeSearch.unfocus();
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
                height: screenHeight * 0.018,
              ),
              StreamBuilder(
                stream: _cloudServices.foodCategory(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final foodCategories =
                            snapshot.data as List<FoodCategory>;
                        return Container(
                          height: screenHeight * 0.14,
                          margin: EdgeInsets.only(
                            left: screenWidth * 0.025,
                            right: screenWidth * 0.025,
                          ),
                          child: FoodCategoryListView(
                            foodCategories: foodCategories,
                            onTap: (foodCategory) {
                              _foodCategoryNameController
                                  .add(foodCategory.name);
                            },
                            onSecondTap: () {
                              _foodCategoryNameController.add('all');
                            },
                          ),
                        );
                      } else {
                        return buildFoodCategoryLoadingState(
                          screenHeight,
                          screenWidth,
                        );
                      }
                    default:
                      return buildFoodCategoryLoadingState(
                        screenHeight,
                        screenWidth,
                      );
                  }
                },
              ),
              SizedBox(
                height: screenHeight * 0.018,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.05,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: screenWidth * 0.67,
                        child: Text(
                          'Featured Restaurants',
                          style: TextStyle(
                            fontSize: screenWidth * 0.047,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SofiaPro',
                            color: const Color(0xFF323643),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.04,
                      top: screenHeight * 0.005,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'View All',
                        style: TextStyle(
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SofiaPro',
                          color: const Color(0xFFF56844),
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: const Color(0xFFFE724C),
                    size: screenWidth * 0.025,
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 0.005,
              ),
              StreamBuilder(
                stream: _cloudServices.featuredRestaurantsStream(
                    foodCategoryNameStream: _foodCategoryNameController.stream),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final restaurants = snapshot.data as List<Restaurant>;
                        return Container(
                          height: screenHeight * 0.33,
                          margin: EdgeInsets.only(
                            left: screenWidth * 0.025,
                            right: screenWidth * 0.025,
                          ),
                          child: Align(
                            child: FeaturedRestaurantListView(
                              restaurants: restaurants,
                              onTap: (restaurant) {
                                Navigator.of(context).push(
                                    restaurantProfileRoute(
                                        arguments: [restaurant]));
                              },
                              addToFavourite: (Restaurant restaurant) {
                                _cloudServices.addOrRemoveFavouriteRestaurant(
                                  restaurant: restaurant,
                                  userId: _authProvider.currentUser!.uid,
                                );
                              },
                              isFavourite: (Restaurant restaurant) {
                                return _cloudServices.isRestaurantFavourite(
                                  restaurant: restaurant,
                                  userId: _authProvider.currentUser!.uid,
                                );
                              },
                              calculateRestaurantFee: (
                                String restaurantName,
                              ) async {
                                await _cloudServices.setRestaurantFee(
                                  restaurantName: restaurantName,
                                  userId: _authProvider.currentUser!.uid,
                                );
                              },
                              getRestaurantFee: (String restaurantName) {
                                return _cloudServices.getRestaurantFee(
                                  restaurantName: restaurantName,
                                  userId: _authProvider.currentUser!.uid,
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return buildRestaurantLoadingState(
                            screenHeight, screenWidth);
                      }
                    default:
                      return buildRestaurantLoadingState(
                          screenHeight, screenWidth);
                  }
                },
              ),
              SizedBox(
                height: screenHeight * 0.013,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: screenWidth * 0.67,
                    child: Text(
                      'Popular Items',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SofiaPro',
                        color: const Color(0xFF323643),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              StreamBuilder(
                stream: _cloudServices.popularItemsStream(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case (ConnectionState.waiting):
                    case (ConnectionState.active):
                      if (snapshot.hasData) {
                        final menuItems = snapshot.data as List<MenuItem>;
                        return Container(
                          margin: EdgeInsets.only(
                            left: screenWidth * 0.025,
                            right: screenWidth * 0.025,
                          ),
                          child: Center(
                            child: PopularItemListView(
                              menuItems: menuItems,
                              onTap: (menuItem) {
                                Navigator.of(context).push(
                                  menuItemDetailsRoute(arguments: [menuItem]),
                                );
                              },
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
                          ),
                        );
                      } else {
                        return Center(
                          child: buildMenuItemLoadingState(
                            screenHeight,
                            screenWidth,
                          ),
                        );
                      }
                    default:
                      return Center(
                        child: buildMenuItemLoadingState(
                          screenHeight,
                          screenWidth,
                        ),
                      );
                  }
                },
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 43,
          child: MyBottomNavigationBar(
            currentIndex: 0,
            onTap: (index) async {
              if (index == 2) {
                LoadingScreenWithNoText().show(context: context);
                final restaurantName = await _cartViewRouteProcessing();
                if (restaurantName == null) {
                  if (mounted) {
                    showCartDialog(context);
                    LoadingScreenWithNoText().hide();
                  }
                } else {
                  final Restaurant restaurant = await _cloudServices
                      .getRestaurant(restaurantName: restaurantName);
                  if (mounted) {
                    LoadingScreenWithNoText().hide();
                    Navigator.of(context)
                        .push(cartRoute(arguments: [restaurant]));
                  }
                }
              } else if (index != 0) {
                Navigator.of(context).push(route[index]()!);
              }
            },
          ),
        ),
      ),
    );
  }
}
