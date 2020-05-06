import 'package:flutter/material.dart';
import 'package:givnotes/pages/home.dart';
import 'package:givnotes/pages/notebookPage.dart';
import 'package:givnotes/pages/aboutUs.dart';

class DrawerItems extends StatefulWidget {
  @override
  _DrawerItemsState createState() => _DrawerItemsState();
}

class _DrawerItemsState extends State<DrawerItems> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 40,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logo/logoPhoenix1-inverted.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: null,
          ),
          MyListTileTheme('All Notes', Icon(Icons.library_books, size: 30), HomePage()),
          MyListTileTheme('Notebooks', Icon(Icons.folder, size: 30), Notebooks()),
          MyListTileTheme('Tags', Icon(Icons.bookmark, size: 30)),
          MyListTileTheme('Trash', Icon(Icons.restore_from_trash, size: 30)),
          MyListTileTheme('Configuration', Icon(Icons.settings, size: 30)),
          MyListTileTheme('About Us', Icon(Icons.person, size: 30), AboutUs()),
        ],
      ),
    );
  }
}

class MyListTileTheme extends StatefulWidget {
  final Icon _icon;
  final String _title;
  final Widget _nextPage;

  MyListTileTheme(this._title, this._icon, [this._nextPage]);

  @override
  _MyListTileThemeState createState() => _MyListTileThemeState();
}

class _MyListTileThemeState extends State<MyListTileTheme> {
  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      style: ListTileStyle.list,
      selectedColor: Colors.green,
      child: ListTile(
        // TODO: Check the selected state in drawer items
//        selected: true,
        leading: widget._icon,
        title: Text(widget._title),
        onTap: () {
          Navigator.pop(context);
          if (widget._nextPage != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => widget._nextPage),
            );
          }
        },
      ),
    );
  }
}
