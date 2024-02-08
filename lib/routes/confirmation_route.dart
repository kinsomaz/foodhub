import 'package:flutter/material.dart';
import 'package:foodhub/views/payment/confirmation_screen.dart';

Route confirmationRoute({
  required List<dynamic> arguments,
}) {
  return PageRouteBuilder(
    settings: RouteSettings(
      arguments: arguments,
    ),
    pageBuilder: (context, animation, secondaryAnimation) =>
        const ConfirmationScreen(),
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
