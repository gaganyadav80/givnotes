import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/enums/prefs.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/customAppBar.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:givnotes/utils/permissions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime currentBackPressTime;
  // int count = 0;

  @override
  void initState() {
    super.initState();
    // getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onPop(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        extendBody: true,
        backgroundColor: Colors.white,
        appBar: MyAppBar(Var.setTitle()),
        //
        drawer: DrawerItems(),
        body: Var.pageNavigation[Var.selectedIndex],

        floatingActionButton: Var.selectedIndex != 0
            ? SizedBox.shrink()
            : FloatingActionButton(
                tooltip: 'New Note',
                backgroundColor: Colors.black,
                splashColor: Colors.black,
                elevation: 5,
                child: Icon(Icons.add),
                onPressed: () async {
                  await HandlePermission().requestPermission().then((value) {
                    if (value) {
                      Var.isEditing = true;
                      Var.noteMode = NoteMode.Adding;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ZefyrEdit(noteMode: NoteMode.Adding),
                        ),
                      );
                    } else {
                      if (isPermanentDisabled) {
                        HandlePermission().permanentDisabled(context);
                      }
                      setState(() => Var.selectedIndex = 0);
                    }
                  });
                },
              ),

        // !! Bottom Navigation
        bottomNavigationBar: SnakeNavigationBar(
          elevation: 20,
          shadowColor: Colors.black,
          currentIndex: Var.selectedIndex,
          style: SnakeBarStyle.pinned,
          snakeShape: SnakeShape.indicator,
          snakeColor: Colors.black,
          backgroundColor: Color(0xffFAFAFA),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          shape: BeveledRectangleBorder(
            side: BorderSide(color: Colors.black, width: 0.02 * hm),
          ),
          onPositionChanged: (index) async {
            if (index == 0) Var.isTrash = false;
            setState(() => Var.selectedIndex = index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.book,
                size: 3.5 * hm,
              ),
              title: Text(
                'All Notes',
                style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 1.5 * hm,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.search,
                size: 3.5 * hm,
              ),
              title: Text(
                'Search',
                style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 1.5 * hm,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.bookmark,
                size: 3.5 * hm,
              ),
              title: Text(
                'Tags',
                style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 1.5 * hm,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.person,
                size: 3.5 * hm,
              ),
              title: Text(
                'Profile',
                style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 1.5 * hm,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onPop() async {
    if (Var.selectedIndex != 0) {
      Var.isTrash = false;
      // Var.selectedIndex = 0;
      Navigator.push(
        context,
        PageRouteTransition(
          builder: (context) => HomePage(),
          animationType: AnimationType.fade,
        ),
      );
      return true;
      //
    } else if (Var.selectedIndex == 0) {
      //
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Toast.show(
          'Press back again to exit',
          context,
          duration: 3,
          gravity: Toast.BOTTOM,
          backgroundColor: toastGrey,
          backgroundRadius: 5,
        );
        return false;
        //
      }
      await NotesDB.db.close();
      if (Platform.isAndroid) SystemNavigator.pop();
      return true;
    }
    return false;
  }
}
