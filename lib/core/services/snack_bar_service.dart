import 'package:flutter/material.dart';

class SnackBarService {
  void show(BuildContext context, String message,
      {String? actionLabel, Function? actionOnPress}) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel!,
              onPressed: () {
                if (actionOnPress != null) {
                  actionOnPress();
                }
              })
          : null,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
