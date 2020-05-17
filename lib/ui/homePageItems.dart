import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:givnotes/pages/notesEdit.dart';
import 'package:givnotes/pages/profile.dart';
import 'package:givnotes/pages/home.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:route_transitions/route_transitions.dart';

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.deepOrangeAccent[400];
    var path = Path();
    // !! Edit after / --> init = 5
    path.lineTo(0, size.height - size.height / 1.5);
    // !! Edit after (-) minus --> init = 0
    path.lineTo(size.width / 1.2, size.height - 15);
    //Added this line
    path.relativeQuadraticBezierTo(15, 3, 30, -5);
    // !! Edit after / --> init = 5
    path.lineTo(size.width, size.height - size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// ! Simple AppBar
class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool isNote;

  MyAppBar(this.title, [this.isNote]);

  Widget leading(BuildContext context) {
    if (isNote == true) {
      return IconButton(
        icon: Icon(EvaIcons.arrowBack),
        iconSize: 30,
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      );
    }
  }

  @override
  Size get preferredSize => Size.fromRadius(30.0);

  @override
  Widget build(BuildContext context) {
    return GFAppBar(
      leading: leading(context),
      // bottom: PreferredSize(
      //   child: CustomPaint(
      //     size: Size(double.infinity, 120),
      //     painter: LogoPainter(),
      //   ),
      //   preferredSize: preferredSize,
      // ),
      backgroundColor: Colors.deepOrangeAccent[400],
      elevation: 30,
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
                Icons.library_books,
                color: Colors.black,
              ),
              tooltip: 'All Notes',
              iconSize: 30.0,
              onPressed: () {
                setState(() {
                  TellIndex.selectedIndex = 0;
                });
                Navigator.push(
                  context,
                  PageRouteTransition(
                    builder: (context) => NotesView(isTrash: false),
                    animationType: AnimationType.slide_up,
                  ),
                );
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
              tooltip: 'My Profile',
              iconSize: 30.0,
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteTransition(
                    animationType: AnimationType.slide_up,
                    builder: (context) => MyProfile(),
                  ),
                );
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
        tooltip: 'Add new note',
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            PageRouteTransition(
              builder: (context) => NotesEdit(NoteMode.Adding, false),
              animationType: AnimationType.scale,
              curves: Curves.decelerate,
            ),
          );
        },
      ),
    );
  }
}
