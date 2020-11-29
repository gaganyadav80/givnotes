import 'package:device_info/device_info.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:package_info/package_info.dart';
import 'package:zefyr/zefyr.dart';

// Hive
// keys = bool skip, bool firstLaunch, bool applock, bool biometric, bool compactNotes
// String sortNotes, String passcode, Map<String, String> user = {url, name, email}

Box prefsBox;
AndroidDeviceInfo androidInfo;
PackageInfo packageInfo;

// enum SortNotes { Created, Modified, AZ, ZA }

// * Custom Colors
// final Color lightBlue = Color(0xff91dcf5);
// final Color purple = Color(0xff5A56D0);
// final Color darkGrey = Color(0xff7D9098);
final Color toastGrey = Colors.grey[800];
final Color whiteIsh = Color(0xffFBF8FC);
// final Color red = Color(0xffEC625C);

// * Logic values
bool isSkipped = false;
bool isConnected = false;
bool isFirstLaunch = true;
bool isPermanentDisabled = false;

//TODO make persistant
String sortNotes = 'created';
bool compactTags = false;

errorAlert(BuildContext context, dynamic e) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error occurred!'),
        content: Text('ERROR: $e'),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}

void initInfo() async {
  // IosDeviceInfo iosDeviceInfo;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  androidInfo = await deviceInfo.androidInfo;
  packageInfo = await PackageInfo.fromPlatform();
}

// TODO maybe replace showToast with showFlashToast
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

final ZefyrThemeData zefyrThemeData = ZefyrThemeData(
  bold: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'SFPro'),
  italic: TextStyle(fontStyle: FontStyle.italic, fontFamily: 'SFPro'),
  paragraph: TextBlockTheme(
    style: TextStyle(
      fontSize: 16,
      height: 1.3,
      color: Colors.black,
    ),
    spacing: VerticalSpacing(top: 3),
  ),
  heading1: TextBlockTheme(
    style: TextStyle(
      fontSize: 34.0,
      color: Colors.black.withOpacity(0.7),
      height: 1.15,
      fontWeight: FontWeight.w300,
    ),
    spacing: VerticalSpacing(top: 20.0),
  ),
  heading2: TextBlockTheme(
    style: TextStyle(
      fontSize: 24.0,
      color: Colors.black.withOpacity(0.7),
      height: 1.15,
      fontWeight: FontWeight.normal,
    ),
    spacing: VerticalSpacing(top: 8.0),
  ),
  heading3: TextBlockTheme(
    style: TextStyle(
      fontFamily: 'SFMono',
      fontSize: 20.0,
      color: Colors.black.withOpacity(0.7),
      height: 1.25,
      fontWeight: FontWeight.w500,
    ),
    spacing: VerticalSpacing(top: 8.0),
  ),
  code: TextBlockTheme(
    style: TextStyle(
      color: Colors.white,
      fontFamily: 'SFMono',
      fontSize: 14,
      height: 1.15,
    ),
    spacing: VerticalSpacing(top: 0.0),
    decoration: BoxDecoration(
      color: Colors.grey[800].withOpacity(1),
      borderRadius: BorderRadius.circular(2),
    ),
  ),
);

// * Skip funcitionality
// void setSkip({bool skip = false}) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setBool('bool', skip);
// }

// Future<bool> getSkip() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getBool('bool');
// }
