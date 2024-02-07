import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/services/auth/firebase_auth_provider.dart';
import 'package:foodhub/services/cloud/database/cloud_profile.dart';
import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
import 'package:foodhub/views/foodhub/order_item.dart';
import 'package:foodhub/views/foodhub/order_item_list_view.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late final FirebaseCloudDatabase _cloudServices;
  late final FirebaseAuthProvider _authProvider;
  late final TabController _tabController;
  GlobalKey upComingKey = GlobalKey();
  GlobalKey historyKey = GlobalKey();
  GlobalKey? selectedKey;

  @override
  void initState() {
    _cloudServices = FirebaseCloudDatabase();
    _authProvider = FirebaseAuthProvider();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          'My Orders',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color(0xFF111719)),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: StreamBuilder(
                stream: _cloudServices.userProfile(
                    ownerUserId: _authProvider.currentUser!.uid),
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
                            imageBuilder: (context, imageProvider) => Container(
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
                    key: upComingKey,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      'Upcoming',
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
                    key: historyKey,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      'History',
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
                  selectedKey = index == 0 ? upComingKey : historyKey;
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
                    stream: _cloudServices.getUpcomingOrder(
                      userId: _authProvider.currentUser!.uid,
                    ),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case (ConnectionState.waiting):
                        case (ConnectionState.active):
                          return Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.15,
                              ),
                              Icon(
                                Icons.assignment,
                                size: screenWidth * 0.4,
                                color: const Color(0xFFFE724C).withOpacity(0.6),
                              ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              Text(
                                'No history orders',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SofiaPro',
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05,
                                ),
                                child: Text(
                                  'No order history is available yet proceed to ordering some food item',
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.037,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'SofiaPro',
                                      color: const Color(0xFF7F7D92)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          );
                        default:
                          return const Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
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
                    stream: _cloudServices.getAllPlacedOrder(
                      userId: _authProvider.currentUser!.uid,
                    ),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case (ConnectionState.waiting):
                        case (ConnectionState.active):
                          if (snapshot.hasData) {
                            final orderItems = snapshot.data as List<OrderItem>;
                            return Container(
                              margin: EdgeInsets.only(
                                left: screenWidth * 0.025,
                                right: screenWidth * 0.025,
                              ),
                              child: OrderItemListView(
                                orderItems: orderItems,
                              ),
                            );
                          } else {
                            return Column(
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.15,
                                ),
                                Icon(
                                  Icons.assignment,
                                  size: screenWidth * 0.4,
                                  color:
                                      const Color(0xFFFE724C).withOpacity(0.6),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                Text(
                                  'No history orders',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SofiaPro',
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05,
                                  ),
                                  child: Text(
                                    'No order history is available yet proceed to ordering some food item',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.037,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'SofiaPro',
                                        color: const Color(0xFF7F7D92)),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            );
                          }
                        default:
                          return const Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
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
