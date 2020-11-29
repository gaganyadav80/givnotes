import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:givnotes/pages/notesView.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/pages/zefyrEdit.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  const MyAppBar(this.title, this.notesModelSheet, {Key key}) : super(key: key);

  final String title;
  final Function notesModelSheet;

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(90);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GFAppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            color: Colors.black,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          actions: [
            Var.selectedIndex == 0
                ? IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      widget.notesModelSheet(context);
                    },
                  )
                : SizedBox.shrink(),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          height: 30,
          child: Padding(
            padding: EdgeInsets.only(left: 3.47 * wm),
            child: Text(
              widget.title,
              style: TextStyle(
                fontFamily: 'Abril',
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w400,
                wordSpacing: 3,
              ),
            ),
          ),
        ),
        // SizedBox(height: 1.23 * hm),
      ],
    );
  }
}

class ZefyrEditAppBar extends StatelessWidget with PreferredSizeWidget {
  final Function saveNote;
  final FlareControls controls;
  const ZefyrEditAppBar({
    @required this.saveNote,
    @required this.controls,
    Key key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return GFAppBar(
      leading: Padding(
        padding: EdgeInsets.fromLTRB(8.5, 4.7, 8.5, 4.7),
        // padding: EdgeInsets.only(
        //   top: 0.62 * hm,
        //   bottom: (0.62 * hm),
        //   left: (1.16 * wm) + wm,
        //   right: (1.16 * wm) + wm,
        // ),
        child: InkWell(
          onTap: () {
            saveNote();
          },
          child: FlareActor(
            'assets/animations/arrow-tick.flr',
            animation: Var.noteMode == NoteMode.Adding ? 'idle-tick' : 'idle-arrow',
            controller: controls,
            alignment: Alignment.center,
            fit: BoxFit.contain,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
      // // TODO maybe remove it
      // title: Text(
      //   Var.isTrash ? 'DELETED NOTE' : 'NOTE',
      //   style: TextStyle(
      //     fontFamily: 'Abril',
      //     color: Colors.black,
      //     fontSize: 2.8 * hm,
      //     fontWeight: FontWeight.w400,
      //     wordSpacing: 0.7 * wm,
      //   ),
      // ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    );
  }
}

// extends with SingleTickerProviderStateMixin
//
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
// @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
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

// Scaffold.of(context).showSnackBar(SnackBar(
//   content: Text("Can't save empty note. Please add a title!"),
//   duration: Duration(seconds: 2),
// ));
