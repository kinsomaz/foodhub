import 'package:flutter/material.dart';
import 'package:foodhub/utilities/dialogs/generic_dialog.dart';

Future<void> showVerificationDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'Verification Needed',
    content: text,
    optionBuilder: () => {
      'OK': null,
    },
  );
}
