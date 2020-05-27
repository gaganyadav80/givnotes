import 'package:flutter/material.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/homePageItems.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   drawer: DrawerItems(),
    //   appBar: MyAppBar('Search'),
    // extendBody: true,
    return SafeArea(
      child: Container(
        // margin: EdgeInsets.only(top: 50),
        height: 400,
        width: double.infinity,
        child: Lottie.asset('assets/animations/search-2.json'),
      ),
    );
    //   floatingActionButton: ActionBarMenu(),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    //   bottomNavigationBar: BottomMenu(),
    // );
  }
}
