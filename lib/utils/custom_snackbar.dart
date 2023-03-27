import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show(BuildContext context, String message, SnackBarType type) {
    final SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.grey[800],
      content: Row(
        children: [
          type == SnackBarType.success
              ? const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 30.0,
                )
              : type == SnackBarType.error
                  ? const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 30.0,
                    )
                  : type == SnackBarType.warning
                      ? const Icon(
                          Icons.warning_amber_outlined,
                          color: Colors.yellow,
                          size: 30.0,
                        )
                      : const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 30.0,
                        ),
          const SizedBox(width: 10.0),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

enum SnackBarType { success, error, warning, info }
