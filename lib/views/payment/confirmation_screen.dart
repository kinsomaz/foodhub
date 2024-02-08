import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodhub/constants/routes.dart';
import 'package:foodhub/helpers/loading/loading_screen_with_no_text.dart';
import 'package:foodhub/routes/payment_success_route.dart';
import 'package:foodhub/services/auth/firebase_auth_provider.dart';
import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
import 'package:foodhub/utilities/zigzag.dart';
import 'package:foodhub/views/restaurant/restaurant.dart';
import 'package:foodhub/views/payment/card_processing_screen.dart';
import 'package:foodhub/views/payment/transfer_processing_screen.dart';
import 'package:intl/intl.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({
    super.key,
  });

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _offsetAnimations;
  late final FirebaseCloudDatabase _cloudServices;
  late final FirebaseAuthProvider _authProvider;

  @override
  void initState() {
    _cloudServices = FirebaseCloudDatabase();
    _authProvider = FirebaseAuthProvider();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _offsetAnimations = List.generate(10, (index) {
      return Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index / 5, (index + 1) / 5, curve: Curves.easeInOut),
        ),
      );
    });
    _controller.forward();
    super.initState();
  }

  Future<void> _placeOrder({
    required Restaurant restaurant,
    required String time,
    required int total,
    required List<Map> items,
  }) async {
    LoadingScreenWithNoText().show(context: context);
    await _cloudServices
        .placeNewOrder(
      userId: _authProvider.currentUser!.uid,
      restaurantName: restaurant.name,
      restaurantLogo: restaurant.logo,
      orderedTime: time,
      totalPrice: '$total',
      numberOfItems: '${items.length}',
      menuItems: items,
      isRestaurantVerified: restaurant.isVerified,
    )
        .whenComplete(() {
      LoadingScreenWithNoText().hide();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final paymentMethod = arguments[0] as String;
    final items = arguments[1] as List<Map>;
    final total = arguments[2] as int;
    final restaurant = arguments[3] as Restaurant;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  height: screenHeight * 0.2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBEBEBE).withAlpha(50),
                  ),
                  child: CustomPaint(
                    painter: ZigZagPainter(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.07,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.07,
                          ),
                          child: Text(
                            'Creating your order...',
                            style: TextStyle(
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SofiaPro',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.009,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.07,
                          ),
                          child: Text(
                            'Is everything correct?',
                            style: TextStyle(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'SofiaPro',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.037,
                ),
                SlideTransition(
                  position: _offsetAnimations[0],
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                    ),
                    child: Row(
                      children: [
                        Builder(builder: (context) {
                          IconData icon = FontAwesomeIcons.ccMastercard;
                          if (paymentMethod == 'Bank Transfer') {
                            icon = Icons.account_balance;
                          } else if (paymentMethod == 'Pay with Cash') {
                            icon = Icons.attach_money;
                          }
                          return Icon(icon);
                        }),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                          ),
                          child: Text(
                            paymentMethod,
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'SofiaPro',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.037,
                ),
                SlideTransition(
                  position: _offsetAnimations[1],
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: const Color(0xFFBEBEBE).withAlpha(100),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.028,
                ),
                Wrap(
                  runSpacing: screenHeight * 0.02,
                  children: List.generate(
                    items.length,
                    (index) => SlideTransition(
                      position: _offsetAnimations[index + 2],
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.07,
                          vertical: screenHeight * 0.006,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${items[index]['item']['quatity']}x',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'SofiaPro',
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.03,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${items[index]['item']['name']}',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'SofiaPro',
                                  ),
                                ),
                                Builder(builder: (context) {
                                  String text = '';
                                  final extras = items[index]['extra'] as Map;
                                  for (var key in extras.keys) {
                                    final extraName = extras[key]['name'];
                                    text += '$extraName';
                                    text += ', ';
                                  }
                                  if (text.isNotEmpty) {
                                    return Text(
                                      text,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.039,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'SofiaPro',
                                        color: const Color(0xFF000000)
                                            .withOpacity(0.35),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(children: [
                  Container(
                    height: 3.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFE724C).withOpacity(0.3),
                    ),
                  ),
                  TweenAnimationBuilder(
                    duration: const Duration(
                      seconds: 8,
                    ),
                    tween: Tween<double>(begin: 0.0, end: screenWidth),
                    builder: (context, double value, child) {
                      final timeout =
                          _offsetAnimations[items.length + 1].isCompleted;
                      if (timeout) {
                        return TweenAnimationBuilder(
                          duration: const Duration(
                            seconds: 4,
                          ),
                          tween: Tween<double>(begin: 0.0, end: screenWidth),
                          builder: (BuildContext context, double value,
                              Widget? child) {
                            return Container(
                              height: 3.5,
                              width: value,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFE724C),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            );
                          },
                          onEnd: () async {
                            if (paymentMethod == 'Bank Transfer') {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TransferProcessingScreen(
                                  total: total,
                                  items: items,
                                  restaurant: restaurant,
                                ),
                              ));
                            } else if (paymentMethod == 'Pay with Cash') {
                              const message = '';
                              DateTime now = DateTime.now();
                              String formattedTime =
                                  DateFormat('dd MMM, HH:mm').format(now);
                              await _placeOrder(
                                restaurant: restaurant,
                                time: formattedTime,
                                total: total,
                                items: items,
                              );
                              if (mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  paymentSuccessRoute(arguments: [message]),
                                  ModalRoute.withName(homeRoute),
                                );
                              }
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CardProcessingScreen(
                                  paymentMethod: paymentMethod,
                                  total: total,
                                  items: items,
                                  restaurant: restaurant,
                                ),
                              ));
                            }
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ]),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.03,
                      ),
                      child: Text(
                        'Modify your order',
                        style: TextStyle(
                          fontSize: screenWidth * 0.041,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SofiaPro',
                          color: const Color(0xFFFE724C),
                        ),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
