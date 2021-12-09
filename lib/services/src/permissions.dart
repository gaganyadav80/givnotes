import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'variables.dart';

abstract class HandlePermission {
  static Future<bool> requestPermission() async {
    await Permission.storage.request();
    if (await Permission.storage.isGranted) {
      return true;
    } else {
      if (await Permission.storage.isPermanentlyDenied) {
        VariableService().isPermanentDisabled = true;
        return false;
      }
      return false;
    }
  }

  static Future<void> permanentDisabled(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Open Settings?'),
          content: const Text('Go to settings to enable storage permission.'),
          actions: [
            TextButton(
              child: const Text("Later"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Sure"),
              onPressed: () {
                Navigator.pop(context);

                openAppSettings();
              },
            )
          ],
        );
      },
    );
  }
}
