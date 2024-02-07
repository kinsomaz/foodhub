import 'package:flutter/material.dart';
import 'package:foodhub/constants/routes.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final message = arguments[0] as String;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                Image.asset(
                  'assets/succes_image.png',
                  height: screenHeight * 0.4,
                ),
                SizedBox(
                  height: screenHeight * 0.08,
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: screenWidth * 0.047,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Text(
                  'Order Placed Successfully',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SofiaPro',
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                SizedBox(
                  width: screenWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(homeRoute, (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFFE724C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5.0,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Text(
                        'Back to Restaurant',
                        style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SofiaPro',
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
