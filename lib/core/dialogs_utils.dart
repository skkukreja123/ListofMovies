import 'package:flutter/material.dart';

class DialoagUtils {
  static void showMyDialog(BuildContext context,
      {String? title, String? message, bool isError = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? "Default Title"),
          content: Text(message ?? "Default Message"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    // Implement your dialog display logic here
    print("Title: $title");
    print("Message: $message");
  }
}
