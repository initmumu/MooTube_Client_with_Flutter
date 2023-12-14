import 'package:flutter/cupertino.dart';

import 'dart:async';

import 'package:flutter/material.dart';

class Alert {
  static void toast(BuildContext context, String alertMessage) {
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Timer(const Duration(milliseconds: 800), () {
          Navigator.of(context).pop();
        });

        return CupertinoActionSheet(
          message: Text(
            alertMessage,
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }
}
