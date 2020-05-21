import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:givnotes/ui/homePageItems.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<String> _appBarTitle = [
    'ALL NOTES',
    'SEARCH',
    'FAVOURITES',
    'NEW NOTE',
    'EDIT NOTE',
    'DELETED NOTE',
    '',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      
      appBar: MyAppBar(_appBarTitle[0]),
      backgroundColor: Colors.white,
      bottomNavigationBar: SnakeNavigationBar(
        currentIndex: _selectedIndex,
        style: SnakeBarStyle.pinned,
        snakeShape: SnakeShape.rectangle,
        snakeColor: Colors.black,
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        onPositionChanged: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.bookOpenOutline),
            title: Text('tickets'),
          ),
        ],
      ),
    );
  }
}
