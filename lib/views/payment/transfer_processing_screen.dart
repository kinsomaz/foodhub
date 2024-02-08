import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:foodhub/constants/routes.dart';
import 'package:foodhub/helpers/loading/loading_screen_with_no_text.dart';
import 'package:foodhub/routes/payment_success_route.dart';
import 'package:foodhub/services/auth/firebase_auth_provider.dart';
import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
import 'package:foodhub/services/paystack/constant.dart';
import 'package:foodhub/views/restaurant/restaurant.dart';
import 'package:intl/intl.dart';

class TransferProcessingScreen extends StatefulWidget {
  final int total;
  final List<Map> items;
  final Restaurant restaurant;
  const TransferProcessingScreen({
    super.key,
    required this.total,
    required this.items,
    required this.restaurant,
  });

  @override
  State<TransferProcessingScreen> createState() =>
      _TransferProcessingScreenState();
}

class _TransferProcessingScreenState extends State<TransferProcessingScreen> {
  late final FirebaseCloudDatabase _cloudServices;
  late final FirebaseAuthProvider _authProvider;
  final plugin = PaystackPlugin();
  String message = '';

  @override
  void initState() {
    _cloudServices = FirebaseCloudDatabase();
    _authProvider = FirebaseAuthProvider();
    plugin.initialize(publicKey: paystackPublicKey);

    Future.delayed(const Duration(seconds: 3), () {
      makePayment();
    });

    super.initState();
  }

  Future<void> makePayment() async {
    int total0 = widget.total.toInt() * 100;
    Charge charge = Charge()
      ..amount = total0
      ..reference = 'ref_${DateTime.now()}'
      ..email = _authProvider.currentUser!.email
      ..currency = 'NGN'
      ..accessCode = paystackPublicKey;

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.bank,
      charge: charge,
    );

    if (response.status == true) {
      message = 'Payment was successful. Ref: ${response.reference}';
      DateTime now = DateTime.now();
      String formattedTime = DateFormat('dd MMM, HH:mm').format(now);
      if (mounted) {
        LoadingScreenWithNoText().show(context: context);
      }

      await _cloudServices
          .placeNewOrder(
        userId: _authProvider.currentUser!.uid,
        restaurantName: widget.restaurant.name,
        restaurantLogo: widget.restaurant.logo,
        orderedTime: formattedTime,
        totalPrice: '${widget.total}',
        numberOfItems: '${widget.items.length}',
        menuItems: widget.items,
        isRestaurantVerified: widget.restaurant.isVerified,
      )
          .whenComplete(
        () {
          LoadingScreenWithNoText().hide();
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              paymentSuccessRoute(
                arguments: [message],
              ),
              ModalRoute.withName(homeRoute),
            );
          }
        },
      );
    } else if (response.status == false &&
        response.message == 'Transaction terminated') {
      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Payment pending',
                  style: TextStyle(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SofiaPro',
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.3,
                ),
                Container(
                  width: 40,
                  height: 40,
                  constraints: const BoxConstraints(
                    maxHeight: 40,
                    minHeight: 40,
                  ),
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                Text(
                  'Your payment is being processed \n Please wait a moment.',
                  style: TextStyle(
                    fontSize: screenWidth * 0.041,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'SofiaPro',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
