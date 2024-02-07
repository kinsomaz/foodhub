import 'package:flutter/material.dart';
import 'package:foodhub/views/payment/payment_success.dart';

Route paymentSuccessRoute({
  required List<dynamic> arguments,
}) {
  return PageRouteBuilder(
    settings: RouteSettings(
      arguments: arguments,
    ),
    pageBuilder: (context, animation, secondaryAnimation) =>
        const PaymentSuccess(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
