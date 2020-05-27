import 'package:flutter/material.dart';

class Notebooks extends StatefulWidget {
  @override
  _NotebooksState createState() => _NotebooksState();
}

class _NotebooksState extends State<Notebooks> {
  @override
  Widget build(BuildContext context) {
    // return SafeArea(
    //   child: Scaffold(
    //     backgroundColor: Colors.white,
    //     drawer: DrawerItems(),
    //     appBar: MyAppBar('NOTEBOOKS'),
    return SafeArea(
      child: ListView(
        children: <Widget>[
          ListTileTheme(
            style: ListTileStyle.list,
            selectedColor: Colors.green,
            child: ListTile(
              leading: Icon(
                Icons.folder,
                size: 30,
              ),
              title: Text('Notebooks'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
    //     floatingActionButton: ActionBarMenu(),
    //     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    //     bottomNavigationBar: BottomMenu(),
    //   ),
    // );
  }
}
