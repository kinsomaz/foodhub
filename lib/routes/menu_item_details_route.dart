import 'package:flutter/material.dart';
import 'package:foodhub/constants/routes.dart';
import 'package:foodhub/views/foodhub/menu_item_details_view.dart';

Route menuItemDetailsRoute({
  required List<dynamic> arguments,
}) {
  return PageRouteBuilder(
    settings: RouteSettings(
      name: menuItemDetailsRouteName,
      arguments: arguments,
    ),
    pageBuilder: (context, animation, secondaryAnimation) =>
        const MenuItemDetailsView(),
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
