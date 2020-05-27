import 'package:flutter/material.dart';
import 'package:givnotes/pages/aboutUs.dart';
import 'package:givnotes/pages/notebookPage.dart';
import 'package:givnotes/pages/notesView.dart';
import 'package:givnotes/pages/profile.dart';
import 'package:givnotes/pages/tagsView.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/utils/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color lightBlue = Color(0xff91dcf5), purple = Color(0xff5A56D0), darkGrey = Color(0xff7D9098);
bool isSkipped;
bool isTrash = false;
Color whiteIsh = Color(0xffFBF8FC);
Color red = Color(0xffEC625C);

void setSkip({bool skip}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('bool', skip);
}

Future<bool> getSkip() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('bool');
}

class Var {
  static int selectedIndex = 0;
  static bool isTrash = false;
  static bool isZefyrNote = false;
  static bool isNote = false;
  static Map<String, dynamic> note;
  static NoteMode noteMode = NoteMode.Adding;

  static List<Widget> pageNavigation = [
    NotesView(isTrash: false),
    SearchPage(),
    // TODO: seperate Editing and Adding
    Var.isZefyrNote == true
        ? ZefyrEdit(Var.noteMode, Var.isTrash)
        : ZefyrEdit(Var.noteMode, Var.isTrash, Var.note),
    TagsView(),
    MyProfile(),
    NotesView(isTrash: true),
    AboutUs(),
    // Config
    null,
    Notebooks(),
  ];

  static String setTitle() {
    if (Var.selectedIndex != 2) Var.isNote = false;

    if (Var.selectedIndex == 0)
      return _appBarTitle[0];
    else if (Var.selectedIndex == 5)
      return _appBarTitle[1];
    else if (Var.selectedIndex == 1)
      return _appBarTitle[2];
    else if (Var.selectedIndex == 2 && isTrash == false) {
      Var.isNote = true;
      return _appBarTitle[4];
    } else if (Var.selectedIndex == 2 && isTrash == true) {
      Var.isNote = true;
      return _appBarTitle[5];
    } else if (Var.selectedIndex == 3)
      return _appBarTitle[3];
    else if (Var.selectedIndex == 4)
      return _appBarTitle[9];
    else if (Var.selectedIndex == 6)
      return _appBarTitle[6];
    else if (Var.selectedIndex == 7)
      return _appBarTitle[7];
    else if (Var.selectedIndex == 8)
      return _appBarTitle[8];
    else
      return '';
  }
}

List<String> _appBarTitle = [
  'ALL NOTES',
  'TRASH',
  'SEARCH',
  'FAVOURITES/TAGS',
  Var.noteMode == NoteMode.Adding ? 'NEW NOTE' : 'EDIT NOTE',
  'DELETED NOTE',
  'ABOUT US',
  'CONFIGURATION',
  'NOTEBOOKS',
  'PROFILE'
];

// class LogoPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint();
//     paint.color = Colors.black;
//     var path = Path();
//     // !! Edit after / --> init = 5
//     path.lineTo(0, size.height - size.height / 1.5);
//     // !! Edit after (-) minus --> init = 0
//     path.lineTo(size.width / 1.2, size.height - 15);
//     //Added this line
//     path.relativeQuadraticBezierTo(15, 3, 30, -5);
//     // !! Edit after / --> init = 5
//     path.lineTo(size.width, size.height - size.height / 3);
//     path.lineTo(size.width, 0);
//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
