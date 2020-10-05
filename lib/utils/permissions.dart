import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/variables/prefs.dart';
import 'package:google_fonts/google_fonts.dart';
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
            FlatButton(
              child: Text(
                "Later",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 2.5 * hm,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text(
                "Sure",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 2.5 * hm,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
