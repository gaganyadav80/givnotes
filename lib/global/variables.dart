import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:givnotes/database/HiveDB.dart';
import 'package:package_info/package_info.dart';
import 'package:quotes/quotes.dart';

PrefsModel prefsBox;
PackageInfo packageInfo;
final quotesProvider = Quotes.getRandom();
bool isPermanentDisabled = true;

enum NoteMode { Adding, Editing }

void showFlashToast(BuildContext context, String msg) {
  showFlash(
    context: context,
    duration: Duration(seconds: 5),
    builder: (_, controller) {
      return Flash(
        controller: controller,
        backgroundColor: Colors.grey[800],
        borderRadius: BorderRadius.circular(5),
        position: FlashPosition.bottom,
        style: FlashStyle.floating,
        enableDrag: false,
        margin: EdgeInsets.only(bottom: 10),
        onTap: () => controller.dismiss(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white),
            child: Text(msg),
          ),
        ),
      );
    },
  );
}
