import 'package:flutter/material.dart';

Future<bool?> customDialog({
  required String title,
  required String msg,
  required BuildContext context,
  bool? isConfirmedNeeded,
  Function? isConfirmedHandler,
}) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        if (isConfirmedNeeded != null && isConfirmedNeeded) ...[
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
        ] else
          TextButton(
            onPressed: () => isConfirmedHandler!(),
            child: const Text('OK'),
          ),
      ],
    ),
  );
}

SnackBar customSnackBar({
  required String text,
  bool? showAction,
  Function? actionHandler,
}) {
  return SnackBar(
    content: Text(
      text,
      textAlign: TextAlign.center,
    ),
    duration: const Duration(seconds: 2),
    action: showAction != null && showAction
        ? SnackBarAction(
            label: 'UNDO',
            onPressed: () => actionHandler != null ? actionHandler() : null,
          )
        : null,
  );
}
