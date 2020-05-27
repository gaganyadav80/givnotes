import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/utils/search.dart';
import 'package:lottie/lottie.dart';
import 'package:route_transitions/route_transitions.dart';

// ! Simple AppBar
class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final bool isNote;

  MyAppBar(this.title, [this.isNote]);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(116);
}

class _MyAppBarState extends State<MyAppBar> {
  Widget leading(BuildContext context) {
    if (widget.isNote == true) {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: IconButton(
          icon: Lottie.asset('assets/animations/back-arrow.json'),
          color: Colors.black,
          iconSize: 30,
          onPressed: () {
            // Navigator.pop(context);
            setState(() {
              Var.noteMode = NoteMode.Adding;
              Var.selectedIndex = 0;
              Var.isTrash = false;
            });
          },
        ),
      );
    } else {
      return IconButton(
        icon: Lottie.asset('assets/animations/menu-loading-black.json'),
        color: Colors.black,
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        GFAppBar(
          leading: leading(context),
          backgroundColor: whiteIsh,
          elevation: 0,
          centerTitle: true,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            widget.title,
            style: TextStyle(
              fontFamily: 'Abril',
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w400,
              letterSpacing: 2,
              wordSpacing: 3,
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
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
      color: Colors.black,
      elevation: 30.0,
      shape: CircularNotchedRectangle(),
      child: Container(
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                CupertinoIcons.book,
                color: Colors.white,
              ),
              tooltip: 'All Notes',
              iconSize: 26,
              onPressed: () {
                // setState(() {
                //   Var.selectedIndex = 0;
                // });
                // Navigator.push(
                //   context,
                //   PageRouteTransition(
                //     builder: (context) => NotesView(isTrash: false),
                //     animationType: AnimationType.slide_up,
                //   ),
                // );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: IconButton(
                icon: Icon(
                  CupertinoIcons.search,
                  color: Colors.white,
                ),
                tooltip: 'Search Notes',
                iconSize: 26,
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteTransition(
                      builder: (context) => SearchPage(),
                      animationType: AnimationType.slide_up,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: IconButton(
                icon: Icon(
                  CupertinoIcons.heart,
                  color: Colors.white,
                ),
                tooltip: 'Favourites',
                iconSize: 26,
                onPressed: () {},
              ),
            ),
            IconButton(
              icon: Icon(
                CupertinoIcons.person,
                color: Colors.white,
              ),
              tooltip: 'My Profile',
              iconSize: 26,
              onPressed: () {
                // Navigator.push(
                //   context,
                //   PageRouteTransition(
                //     animationType: AnimationType.slide_up,
                //     builder: (context) => MyProfile(),
                //   ),
                // );
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

class _ActionBarMenuState extends State<ActionBarMenu> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: FloatingActionButton(
        elevation: 10.0,
        backgroundColor: Colors.black,
        tooltip: 'Add new note',
        child: Icon(Icons.add),
        onPressed: () {
          // Navigator.push(
          //   context,
          //   PageRouteTransition(
          //     builder: (context) => ZefyrEdit(NoteMode.Adding, false),
          //     animationType: AnimationType.scale,
          //   ),
          // );
        },
      ),
    );
  }
}

// AnimationController _controller;
// bool expanded = true;
// @override
// void initState() {
//   super.initState();
//   _controller = AnimationController(
//     vsync: this,
//     duration: Duration(milliseconds: 400),
//     reverseDuration: Duration(milliseconds: 400),
//   );
// }
// IconButton(
//   icon: AnimatedIcon(
//     color: Colors.black,
//     icon: AnimatedIcons.menu_arrow,
//     progress: _controller,
//     semanticLabel: 'Show menu',
//   ),
//   onPressed: () {
//     setState(() {
//       expanded ? _controller.forward() : _controller.reverse();
//       expanded = !expanded;
//     });
//   },
// );
