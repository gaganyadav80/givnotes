import 'package:flutter/material.dart';
import 'package:givnotes/pages/home.dart';
import 'package:givnotes/pages/notebookPage.dart';
import 'package:givnotes/pages/aboutUs.dart';
import 'package:givnotes/pages/trash.dart';

class DrawerItems extends StatefulWidget {
  @override
  _DrawerItemsState createState() => _DrawerItemsState();
}

class _DrawerItemsState extends State<DrawerItems> {
  static int _selectedIndex = 0;

  List<IconData> _icons = [
    Icons.library_books,
    Icons.folder,
    Icons.bookmark,
    Icons.restore_from_trash,
    Icons.settings,
    Icons.person,
  ];

  Widget myListTileTheme(String title, int index, [Widget nextPage]) {
    return ListTileTheme(
      selectedColor: Colors.green,
      child: ListTile(
        selected: _selectedIndex == index ? true : false,
        leading: Icon(
          _icons[index],
          size: 30,
        ),
        title: Text(title),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          Navigator.pop(context);
          if (nextPage != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => nextPage),
            );
          }
        },
      ),
    );
  }

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
          // TODO : point the pages to remaining
          myListTileTheme('All Notes', 0, HomePage()),
          myListTileTheme('Notebooks', 1, Notebooks()),
          myListTileTheme('Tags', 2),
          myListTileTheme('Trash', 3, Trash()),
          myListTileTheme('Configuration', 4),
          myListTileTheme('About Us', 5, AboutUs()),
        ],
      ),
    );
  }
}
