import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:package_info/package_info.dart';

// Hive
// keys = bool skip, bool firstLaunch, Map<String, String> user
Box prefsBox;
AndroidDeviceInfo androidInfo;
PackageInfo packageInfo;

// * Custom icon
// final IconData trashIcon = IconData(0xe811, fontFamily: 'TrashIcon', fontPackage: null);

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

errorAlert(BuildContext context, dynamic e) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error sign in!'),
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

// * Skip funcitionality
// void setSkip({bool skip = false}) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setBool('bool', skip);
// }

// Future<bool> getSkip() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getBool('bool');
// }

// * Check first launch
// void setFirstLaunch({bool isFirstLaunch = true}) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setBool('isFirstLaunch', isFirstLaunch);
// }

// Future<bool> getFirstLauch() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getBool('isFirstLaunch');
// }
