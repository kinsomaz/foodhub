import 'package:flutter/material.dart';
import 'package:foodhub/utilities/dialogs/generic_dialog.dart';

Future<bool> showConfirmationDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Confirmation',
    content: 'Are you sure you\'ve entered the correct information',
    optionBuilder: () => {
      'Cancel': false,
      'Confirm': true,
    },
  ).then((value) => value ?? false);
}
