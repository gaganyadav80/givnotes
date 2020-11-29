import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:givnotes/database/hive_db_helper.dart';
import 'package:givnotes/packages/toast.dart';
import 'package:givnotes/pages/notesView.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/variables/prefs.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/customAppBar.dart';
import 'package:route_transitions/route_transitions.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  DateTime currentBackPressTime;

  void _rebuildHome() {
    setState(() {});
  }

  void modalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return NotesModelSheet();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onPop(),
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        // extendBody: true,
        backgroundColor: Colors.white,
        appBar: MyAppBar(Var.setTitle(), modalSheet),
        //
        drawer: DrawerItems(
          rebuildHome: _rebuildHome,
        ),
        body: Var.pageNavigation[Var.selectedIndex],

        // !! Bottom Navigation
        bottomNavigationBar: SnakeNavigationBar(
          elevation: 10,
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
                size: 6.62 * wm,
              ),
              label: 'All Notes',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.search,
                size: 6.62 * wm,
              ),
              label: 'Seach',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.bookmark,
                size: 6.62 * wm,
              ),
              label: 'Tags',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.person,
                size: 6.62 * wm,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onPop() async {
    if (Var.selectedIndex != 0) {
      Var.isTrash = false;
      Var.selectedIndex = 0;
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
      if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
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

      HiveDBServices()?.closeBox();
      prefsBox?.close();
      if (Platform.isAndroid) SystemNavigator.pop();
      return true;
    }
    return false;
  }
}
