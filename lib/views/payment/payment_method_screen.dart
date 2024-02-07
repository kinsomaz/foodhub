import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodhub/routes/add_new_card_route.dart';
import 'package:foodhub/services/auth/firebase_auth_provider.dart';
import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
import 'package:foodhub/views/payment/card_information.dart';
import 'package:foodhub/views/payment/credit_card_list_view.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  late final FirebaseCloudDatabase _cloudServices;
  late final FirebaseAuthProvider _authProvider;
  bool isTapped = false;

  @override
  void initState() {
    _cloudServices = FirebaseCloudDatabase();
    _authProvider = FirebaseAuthProvider();
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
          'Manage payment methods',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color(0xFF111719)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: screenWidth * 0.01,
                left: screenWidth * 0.05,
              ),
              child: SizedBox(
                height: screenHeight * 0.03,
                child: Text(
                  'SAVED PAYMENT METHODS',
                  style: TextStyle(
                    fontSize: screenWidth * 0.037,
                    fontFamily: 'SofiaPro',
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9796A1),
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: _cloudServices.getAllCards(
                  userId: _authProvider.currentUser!.uid),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case (ConnectionState.waiting):
                  case (ConnectionState.active):
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        final cards = snapshot.data as List<CardInformation>;
                        return Flexible(
                          child: CreditCardListView(
                            cards: cards,
                            onTap: (card) {},
                          ),
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return Container();
                    }
                  default:
                    return Container();
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                top: screenWidth * 0.04,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    addNewCardRoute(),
                  );
                },
                onTapDown: (_) {
                  setState(() {
                    isTapped = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    isTapped = false;
                  });
                },
                onTapCancel: () {
                  setState(() {
                    isTapped = false;
                  });
                },
                child: SizedBox(
                  height: screenHeight * 0.1,
                  width: double.infinity,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: double.infinity,
                    height: screenHeight * 0.1,
                    decoration: BoxDecoration(
                      color: isTapped
                          ? Colors.black.withAlpha(25)
                          : Colors.transparent,
                    ),
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.01,
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: screenWidth * 0.1,
                              margin: EdgeInsets.only(
                                left: screenWidth * 0.03,
                              ),
                              child: Icon(
                                FontAwesomeIcons.creditCard,
                                size: screenWidth * 0.068,
                                color: const Color(0xFF000000),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: screenWidth * 0.037,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.add_circle,
                                  size: screenWidth * 0.035,
                                  color: const Color(0xFFFE724C),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: screenWidth * 0.02,
                        ),
                        Text(
                          'Add new card',
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: true,
                              applyHeightToLastDescent: false,
                              leadingDistribution:
                                  TextLeadingDistribution.even),
                          style: TextStyle(
                            fontSize: screenWidth * 0.047,
                            fontFamily: 'SofiaPro',
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
