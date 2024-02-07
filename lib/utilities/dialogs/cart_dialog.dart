import 'package:flutter/material.dart';
import 'package:foodhub/utilities/dialogs/generic_dialog.dart';

Future<bool> showCartDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Cart!',
    content: 'You can only order from the same restaurant. One at a time',
    optionBuilder: () => {
      'OK': null,
    },
  ).then((value) => value ?? false);
}
