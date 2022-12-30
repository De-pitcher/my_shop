import 'package:flutter/material.dart';

Future<bool?> customDialog({
  required String msg,
  required BuildContext context,
  Function? isConfirmedHandler,
}) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Are you sure?'),
      content: Text(msg),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
          child: const Text('NO'),
        ),
        TextButton(
          onPressed: () {
            if (isConfirmedHandler != null) {
              isConfirmedHandler();
            }

            Navigator.of(ctx).pop(true);
          },
          child: const Text('YES'),
        ),
      ],
    ),
  );
}
