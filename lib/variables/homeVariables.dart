import 'package:flutter/material.dart';
import 'package:givnotes/pages/aboutUs.dart';
import 'package:givnotes/pages/notesView.dart';
import 'package:givnotes/pages/profile.dart';
import 'package:givnotes/pages/settings.dart';
import 'package:givnotes/pages/tagsView.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/utils/search.dart';
import 'package:givnotes/variables/sizeConfig.dart';

// * Responsive values
double hm = SizeConfig.heightMultiplier;
double wm = SizeConfig.widthMultiplier;

class Var {
  static int selectedIndex = 0;
  static bool isTrash = false;
  static bool isEditing = false;
  // static NotesModel note;
  // static NotesDBData _note;
  static NoteMode noteMode = NoteMode.Adding;

  static List<Widget> pageNavigation = [
    NotesView(isTrash: false), //? 0   --> All Notes
    SearchPage(), //? 1   --> Search
    TagsView(), //? 2   --> Tags
    MyProfile(), //? 3   --> Profile
    NotesView(isTrash: true), //? 4    --> Trash
    AboutUs(), //? 5    --> About Us
    SettingsPage(), //? 6    --> Config
  ];

  static List<String> _appBarTitle = [
    'ALL NOTES',
    'SEARCH',
    'FAVOURITES/TAGS',
    'PROFILE',
    'TRASH',
    'ABOUT US',
    'CONFIGURATION',
    // 'NOTEBOOKS',
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
    } else
      return 'OOPS! ERROR';
  }
}
