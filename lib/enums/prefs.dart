import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// Hive
// keys = bool skip, bool firstLaunch, Map<String, String> user
Box prefsBox;

// * Custom Trash icon
final IconData trashIcon = IconData(0xe800, fontFamily: 'TrashIcon', fontPackage: null);

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
