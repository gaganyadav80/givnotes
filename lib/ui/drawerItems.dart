import 'package:flutter/material.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/pages/notesView.dart';
import 'package:givnotes/pages/notebookPage.dart';
import 'package:givnotes/pages/aboutUs.dart';
import 'package:givnotes/pages/tagsView.dart';
import 'package:givnotes/utils/home.dart';
import 'package:route_transitions/route_transitions.dart';

class DrawerItems extends StatefulWidget {
  @override
  _DrawerItemsState createState() => _DrawerItemsState();
}

class _DrawerItemsState extends State<DrawerItems> {
  List<IconData> _icons = [
    Icons.library_books,
    null,
    null,
    Icons.bookmark,
    null,
    Icons.restore_from_trash,
    Icons.person,
    Icons.settings,
    Icons.folder,
  ];

  Widget myListTileTheme(String title, int index, [Widget nextPage]) {
    return ListTileTheme(
      selectedColor: Color(0xffEC625C),
      child: ListTile(
        selected: Var.selectedIndex == index ? true : false,
        leading: Icon(
          _icons[index],
          size: 30,
        ),
        title: Text(title),
        onTap: () {
          setState(() {
            if (index == 5)
              Var.isTrash = true;
            else
              Var.isTrash = false;

            Var.selectedIndex = index;
          });

          Navigator.pop(context);
          // if (nextPage != null) {
          Navigator.push(
            context,
            PageRouteTransition(
              builder: (context) => HomePage(),
              animationType: AnimationType.slide_left,
            ),
          );
          // }
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
          myListTileTheme('Notebooks', 8, Notebooks()),
          myListTileTheme('Tags', 3, TagsView()),
          myListTileTheme('Trash', 5, NotesView(isTrash: true)),
          myListTileTheme('Configuration', 7),
          myListTileTheme('About Us', 6, AboutUs()),
        ],
      ),
    );
  }
}
