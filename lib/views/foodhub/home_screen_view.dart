import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/constants/routes.dart';
import 'package:foodhub/helpers/loading/loadind_screen_for_food_category.dart';
import 'package:foodhub/helpers/loading/loading_screen_for_restaurant.dart';
import 'package:foodhub/icons/custom_search_switch_icon.dart';
import 'package:foodhub/services/auth/firebase_auth_provider.dart';
import 'package:foodhub/services/bloc/food_hub_bloc.dart';
import 'package:foodhub/services/bloc/food_hub_event.dart';
import 'package:foodhub/services/cloud/database/cloud_profile.dart';
import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
import 'package:foodhub/utilities/dialogs/logout_dialog.dart';
import 'package:foodhub/views/foodhub/food_category.dart';
import 'package:foodhub/views/foodhub/food_category_list_view.dart';
import 'package:foodhub/views/foodhub/profile_image.dart';
import 'package:foodhub/views/foodhub/restaurant.dart';
import 'package:foodhub/views/foodhub/restaurant_list_view.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final FirebaseCloudDatabase _cloudServices;
  late final User? _user;
  late AnimationController _waterFlowController;
  late final StreamController<String?> _foodCategoryNameController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _focusNodeSearch = FocusNode();

  @override
  void initState() {
    _searchController = TextEditingController();
    _cloudServices = FirebaseCloudDatabase();
    _user = FirebaseAuthProvider().currentUser;
    _foodCategoryNameController = StreamController<String?>.broadcast(
      onListen: () {
        _foodCategoryNameController.sink.add('all');
      },
    );
    super.initState();
    _focusNodeSearch.addListener(() {
      setState(() {});
    });
    _waterFlowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _foodCategoryNameController.close();
    _focusNodeSearch.dispose();
    _waterFlowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Food Hub'),
        centerTitle: true,
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
                          onTap: () {},
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
                            Navigator.of(context).pushNamed(profileRoute);
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
                          onTap: () {
                            scaffoldKey.currentState!.closeDrawer();
                            Navigator.of(context)
                                .pushNamed(deliveryAddressRoute);
                          },
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
                          onTap: () {},
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * 0.01,
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
                      fontSize: screenWidth * 0.08,
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
                    height: screenHeight * 0.055,
                    width: screenWidth * 0.7,
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
                      decoration: InputDecoration(
                        hintText: 'Find for food or restaurant',
                        hintStyle: TextStyle(
                          fontSize: screenWidth * 0.039,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9AA0B4),
                        ),
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(1.0),
                      ),
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
                    return buildFoodCategoryLoadingState(
                        screenWidth, _waterFlowController);
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final foodCategories =
                          snapshot.data as List<FoodCategory>;
                      return Container(
                        height: 100,
                        margin: EdgeInsets.only(
                          left: screenWidth * 0.025,
                          right: screenWidth * 0.025,
                        ),
                        child: FoodCategoryListView(
                          foodCategories: foodCategories,
                          onTap: (foodCategory) {
                            _foodCategoryNameController.add(foodCategory.name);
                          },
                        ),
                      );
                    } else {
                      return buildFoodCategoryLoadingState(
                          screenWidth, _waterFlowController);
                    }
                  default:
                    return buildFoodCategoryLoadingState(
                        screenWidth, _waterFlowController);
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
                        height: screenHeight * 0.315,
                        margin: EdgeInsets.only(
                          left: screenWidth * 0.025,
                          right: screenWidth * 0.025,
                        ),
                        child: RestaurantListView(
                          restaurants: restaurants,
                          onTap: (restaurant) {},
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
          ],
        ),
      ),
    );
  }
}
