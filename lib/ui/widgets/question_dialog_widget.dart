import 'package:flutter/material.dart';

Future<bool?> questionDialogWidget({
  required BuildContext context,
  required String question,
  Function? onConfirm,
}) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(title: Text(question), actions: [
          TextButton(
              onPressed: () {
                if (onConfirm != null) onConfirm();
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No')),
        ]);
      });
}
