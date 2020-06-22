import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/customAppBar.dart';
import 'package:givnotes/utils/permissions.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: MyAppBar(Var.setTitle(), isNote: false),
      drawer: DrawerItems(),
      body: Var.pageNavigation[Var.selectedIndex],

      floatingActionButton: Var.isTrash
          ? SizedBox.shrink()
          : FloatingActionButton(
              tooltip: 'New Note',
              backgroundColor: Colors.black,
              splashColor: Colors.black,
              elevation: 5,
              child: Icon(
                Icons.add,
              ),
              onPressed: () async {
                await HandlePermission().requestPermission().then((value) {
                  if (value) {
                    Var.isEditing = true;
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
              size: 3 * hm,
            ),
            title: Text(
              'All Notes',
              style: GoogleFonts.ubuntu(
                color: Colors.black,
                fontSize: 1.2 * hm,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.search,
              size: 3 * hm,
            ),
            title: Text(
              'Search',
              style: GoogleFonts.ubuntu(
                color: Colors.black,
                fontSize: 1.2 * hm,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.bookmark,
              size: 3 * hm,
            ),
            title: Text(
              'Tags',
              style: GoogleFonts.ubuntu(
                color: Colors.black,
                fontSize: 1.2 * hm,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.person,
              size: 3 * hm,
            ),
            title: Text(
              'Profile',
              style: GoogleFonts.ubuntu(
                color: Colors.black,
                fontSize: 1.2 * hm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
