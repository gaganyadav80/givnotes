import 'package:flutter/material.dart';
import 'package:givnotes/enums/sizeConfig.dart';
import 'package:givnotes/pages/aboutUs.dart';
import 'package:givnotes/pages/notebookPage.dart';
import 'package:givnotes/pages/notesView.dart';
import 'package:givnotes/pages/profile.dart';
import 'package:givnotes/pages/tagsView.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/utils/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

// * Custom Trash icon
const IconData trashIcon = IconData(0xe800, fontFamily: 'TrashIcon', fontPackage: null);

// * Custom Colors
Color lightBlue = Color(0xff91dcf5);
Color purple = Color(0xff5A56D0);
Color darkGrey = Color(0xff7D9098);
Color whiteIsh = Color(0xffFBF8FC);
Color red = Color(0xffEC625C);

// * Logic values
bool isSkipped = false;
bool isConnected = false;
bool isFirstLaunch = true;
bool isPermanentDisabled = false;

// * Responsive values
double hm = SizeConfig.heightMultiplier;
double wm = SizeConfig.widthMultiplier;

// * Skip funcitionality
void setSkip({bool skip}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('bool', skip);
}

Future<bool> getSkip() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('bool');
}

// * Check first launch
void setFirstLaunch({bool isFirstLaunch = true}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isFirstLaunch', isFirstLaunch);
}

Future<bool> getFirstLauch() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isFirstLaunch');
}

// * Home scaffold body navigation
class Var {
  static int selectedIndex = 0;
  static bool isTrash = false;
  static bool isEditing = false;
  static Map<String, dynamic> note;
  static NoteMode noteMode = NoteMode.Adding;

  static List<Widget> pageNavigation = [
    NotesView(isTrash: false), //? 0   --> All Notes
    SearchPage(), //? 1   --> Search
    TagsView(), //? 2   --> Tags
    MyProfile(), //? 3   --> Profile
    NotesView(isTrash: true), //? 4    --> Trash
    AboutUs(), //? 5    --> About Us
    null, //Config                    //? 6    --> Config
    Notebooks(), //? 7    --> Notebook (temp)
  ];

  static List<String> _appBarTitle = [
    'ALL NOTES',
    'SEARCH',
    'FAVOURITES/TAGS',
    'PROFILE',
    'TRASH',
    'ABOUT US',
    'CONFIGURATION',
    'NOTEBOOKS',
  ];

  static String setTitle() {
    if (selectedIndex == 0) {
      return _appBarTitle[0]; //? All Notes
    } else if (selectedIndex == 1) {
      return _appBarTitle[1]; //? Search
    } else if (selectedIndex == 2) {
      return _appBarTitle[2]; //? Tags
    } else if (Var.selectedIndex == 3) {
      return _appBarTitle[3]; //? Profile
    } else if (Var.selectedIndex == 4) {
      return _appBarTitle[4]; //? Trash
    } else if (selectedIndex == 5) {
      return _appBarTitle[5]; //? About Us
    } else if (Var.selectedIndex == 6) {
      return _appBarTitle[6]; //? Config
    } else if (Var.selectedIndex == 7) {
      return _appBarTitle[7]; //? Notebook
    } else
      return 'OOPS! ERROR';
  }
}
