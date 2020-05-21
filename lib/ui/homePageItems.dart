import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:givnotes/pages/profile.dart';
import 'package:givnotes/pages/notesView.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/utils/search.dart';
import 'package:lottie/lottie.dart';
import 'package:route_transitions/route_transitions.dart';

Color red = Color(0xffEC625C);

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.black;
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
class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final bool isNote;

  MyAppBar(this.title, [this.isNote]);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(106);
}

class _MyAppBarState extends State<MyAppBar> {
  Widget leading(BuildContext context) {
    if (widget.isNote == true) {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: IconButton(
          icon: Lottie.asset('assets/images/back-arrow.json'),
          color: Colors.black,
          iconSize: 30,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    } else {
      return IconButton(
        icon: Lottie.asset('assets/images/menu-loading-black.json'),
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
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          // title: Text(
          //   title,
          //   style: TextStyle(
          //     color: Colors.black,
          //     fontSize: 20,
          //     fontFamily: 'Abril',
          //     letterSpacing: 2,
          //     wordSpacing: 3,
          //   ),
          // ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: 'Abril',
              letterSpacing: 2,
              wordSpacing: 3,
            ),
          ),
        ),
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
                EvaIcons.bookOpenOutline,
                color: Colors.white,
              ),
              tooltip: 'All Notes',
              iconSize: 26,
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
                  EvaIcons.search,
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
                  EvaIcons.heartOutline,
                  color: Colors.white,
                ),
                tooltip: 'Favourites',
                iconSize: 26,
                onPressed: () {},
              ),
            ),
            IconButton(
              icon: Icon(
                EvaIcons.personOutline,
                color: Colors.white,
              ),
              tooltip: 'My Profile',
              iconSize: 26,
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
          Navigator.push(
            context,
            PageRouteTransition(
              builder: (context) => ZefyrEdit(NoteMode.Adding, false),
              animationType: AnimationType.scale,
            ),
          );
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
