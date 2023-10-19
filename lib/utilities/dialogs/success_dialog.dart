import 'package:flutter/material.dart';
import 'package:foodhub/utilities/dialogs/generic_dialog.dart';

Future<void> showSuccessDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'Successful',
    content: text,
    optionBuilder: () => {
      'OK': null,
    },
  );
}
