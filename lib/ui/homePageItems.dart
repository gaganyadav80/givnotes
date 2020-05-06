import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:getflutter/getflutter.dart';
import 'package:givnotes/pages/profile.dart';
import 'package:givnotes/pages/notebookPage.dart';

// ! Simple AppBar
Widget myAppBar(String title) {
  return GFAppBar(
    bottom: PreferredSize(
      child: Container(
        color: Colors.green,
        height: 3,
      ),
      preferredSize: Size(10, 10),
    ),
    elevation: 50,
    searchBar: true,
    centerTitle: true,
    title: Text(
      title, // title
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'SourceSansPro-Light',
        letterSpacing: 3,
      ),
    ),
  );
}

// ! This builds the bottomAppBar icons
class BottomMenu extends StatefulWidget {
  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 30.0,
      shape: CircularNotchedRectangle(),
      child: Container(
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.book,
                color: Colors.black,
              ),
              tooltip: 'Notebooks',
              iconSize: 30.0,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Notebooks()));
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                tooltip: 'Search Notes',
                iconSize: 30.0,
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: IconButton(
                icon: Icon(
                  Icons.star,
                  color: Colors.black,
                ),
                tooltip: 'Favourites',
                iconSize: 30.0,
                onPressed: () {},
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: Colors.black,
              ),
              tooltip: 'My Account',
              iconSize: 30.0,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfile()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ! Action menu at bottom to add new notes
class ActionBarMenu extends StatefulWidget {
  @override
  _ActionBarMenuState createState() => _ActionBarMenuState();
}

class _ActionBarMenuState extends State<ActionBarMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.7),
      child: FloatingActionButton(
        backgroundColor: Colors.black,
        tooltip: 'Add new item',
        child: Icon(Icons.add),
        // TODO: Add entries for action button.
        onPressed: () {},
      ),
    );
  }
}

// ! Floating AppBar
// Widget floatingAppBar(String title) {
//   return Container(
//     margin: EdgeInsets.only(top: 10),
//     child: FloatingSearchBar.builder(
//       pinned: true,
//       title: Text(
//         title,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontFamily: 'SourceSansPro',
//           letterSpacing: 2,
//         ),
//       ),
//       itemCount: 100,
//       itemBuilder: (BuildContext context, int index) {
//         return ListTile(
//           leading: Text(index.toString()),
//         );
//       },
//       drawer: DrawerItems(),
//       onChanged: (String value) {},
//       onTap: () {},
//       // decoration: InputDecoration.collapsed(
//       //   hintText: "Search ...",
//       // ),
//     ),
//   );
// }

// ! This is for the custom topAppBar
// class CustomAppBar extends StatefulWidget {
//   final String title;
//   CustomAppBar(this.title);

//   @override
//   _CustomAppBarState createState() => _CustomAppBarState();
// }

// class _CustomAppBarState extends State<CustomAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(2),
//       height: 80,
//       width: double.infinity,
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(13),
//         ),
//         elevation: 50,
//         color: Colors.black,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             IconButton(
//               padding: EdgeInsets.only(left: 10),
//               icon: Icon(
//                 Icons.menu,
//                 color: Colors.white,
//                 size: 30,
//               ),
//               onPressed: () {
//                 Scaffold.of(context).openDrawer();
//               },
//             ),
//             Text(
//               widget.title, // title
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontFamily: 'SourceSansPro-Light',
//                 letterSpacing: 3,
//               ),
//             ),
//             IconButton(
//               padding: EdgeInsets.only(right: 10),
//               icon: Icon(
//                 Icons.more_vert,
//                 color: Colors.white,
//                 size: 30,
//               ),
//               // TODO: add menu list for entries like sort and delete notes
//               onPressed: () => Scaffold.of(context).openDrawer(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
