import 'package:flutter/material.dart';
import 'package:foodhub/constants/routes.dart';
import 'package:foodhub/views/favourite/favourite_food_item.dart';

Route favouriteRoute() {
  return PageRouteBuilder(
    settings: const RouteSettings(
      name: favouriteFoodItemRouteName,
    ),
    pageBuilder: (context, animation, secondaryAnimation) =>
        const FavouriteFoodItemView(),
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
