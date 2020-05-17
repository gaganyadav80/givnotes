import 'package:flutter/material.dart';
import 'package:givnotes/pages/home.dart';
import 'package:givnotes/pages/notebookPage.dart';
import 'package:givnotes/pages/aboutUs.dart';
import 'package:route_transitions/route_transitions.dart';

class TellIndex {
  static int selectedIndex = 0;
}

class DrawerItems extends StatefulWidget {
  @override
  _DrawerItemsState createState() => _DrawerItemsState();
}

class _DrawerItemsState extends State<DrawerItems> {
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
        selected: TellIndex.selectedIndex == index ? true : false,
        leading: Icon(
          _icons[index],
          size: 30,
        ),
        title: Text(title),
        onTap: () {
          setState(() {
            TellIndex.selectedIndex = index;
          });
          Navigator.pop(context);
          if (nextPage != null) {
            Navigator.push(
              context,
              PageRouteTransition(
                builder: (context) => nextPage,
                animationType: AnimationType.slide_left,
              ),
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
                image: AssetImage('assets/logo/logoOwlCute-inverted.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: null,
          ),
          // TODO : point the pages to remaining
          myListTileTheme('All Notes', 0, NotesView(isTrash: false)),
          myListTileTheme('Notebooks', 1, Notebooks()),
          myListTileTheme('Tags', 2),
          myListTileTheme('Trash', 3, NotesView(isTrash: true)),
          myListTileTheme('Configuration', 4),
          myListTileTheme('About Us', 5, AboutUs()),
        ],
      ),
    );
  }
}
