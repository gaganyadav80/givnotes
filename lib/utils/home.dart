import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/ui/baseWidget.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/homePageItems.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // static var _homeScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, sizingInformation) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true,
          extendBody: true,
          backgroundColor: whiteIsh,
          appBar: MyAppBar(Var.setTitle(), Var.isNote),
          drawer: DrawerItems(),

          // TODO: fix it so I can route other pages in this body
          body: Var.pageNavigation[Var.selectedIndex],

          // !! Bottom Navigation
          bottomNavigationBar: SnakeNavigationBar(
            elevation: 20,
            shadowColor: Colors.black,
            // currentIndex: Var.selectedIndex < 5 ? Var.selectedIndex : 0,
            currentIndex: Var.selectedIndex,
            style: SnakeBarStyle.pinned,
            snakeShape: SnakeShape.indicator,
            snakeColor: Colors.black,
            backgroundColor: whiteIsh,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            shape: BeveledRectangleBorder(
              side: BorderSide(color: Colors.black, width: 0.5),
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(15),
              //   topRight: Radius.circular(15),
              // ),
            ),
            onPositionChanged: (index) {
              if (index == 0) Var.isTrash = false;
              setState(() => Var.selectedIndex = index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.book),
                title: Text('All Notes'),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search),
                title: Text('Search'),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.add_circled),
                title: Text('New Note'),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.bookmark),
                title: Text('Tags'),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                title: Text('Profile'),
              ),
            ],
          ),
        );
      },
    );
  }
}
