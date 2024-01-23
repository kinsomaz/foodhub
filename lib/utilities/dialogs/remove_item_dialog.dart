import 'package:flutter/material.dart';
import 'package:foodhub/utilities/dialogs/generic_dialog.dart';

Future<bool> showRemoveItemDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Remove Item',
    content: 'Do you want to remove this item from your order',
    optionBuilder: () => {
      'Cancel': false,
      'Confirm': true,
    },
  ).then((value) => value ?? false);
}
