import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/constants/routes.dart';
import 'package:foodhub/services/auth/firebase_auth_provider.dart';
import 'package:foodhub/services/bloc/food_hub_bloc.dart';
import 'package:foodhub/services/bloc/food_hub_event.dart';
import 'package:foodhub/services/cloud/database/cloud_profile.dart';
import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
import 'package:foodhub/utilities/dialogs/logout_dialog.dart';
import 'package:foodhub/views/foodhub/conditional_network_image.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  late final FirebaseCloudDatabase _cloudServices;
  late final User? _user;

  @override
  void initState() {
    _cloudServices = FirebaseCloudDatabase();
    _user = FirebaseAuthProvider().currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Food Hub'),
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
                          currentAccountPicture: ConditionalNetworkImage(
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
    );
  }
}
