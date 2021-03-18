import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givnotes/global/variables.dart';
import 'package:permission_handler/permission_handler.dart';

class HandlePermission {
  Future<bool> requestPermission() async {
    await Permission.storage.request();
    if (await Permission.storage.isGranted) {
      return true;
    } else {
      if (await Permission.storage.isPermanentlyDenied) {
        isPermanentDisabled = true;
        return false;
      }
      return false;
    }
  }

  permanentDisabled(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Open Settings?'),
          content: Text('Go to settings to enable storage permission.'),
          actions: [
            TextButton(
              child: Text("Later"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Sure"),
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
