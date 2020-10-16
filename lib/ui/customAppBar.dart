import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/pages/zefyrEdit.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;

  const MyAppBar(this.title, {Key key}) : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(22.7 * wm);
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
          // actions: getAppBarActions(),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          height: 4 * hm,
          child: Padding(
            padding: EdgeInsets.only(left: 3.47 * wm),
            child: Text(
              widget.title,
              style: TextStyle(
                fontFamily: 'Abril',
                color: Colors.black,
                fontSize: 2.8 * hm,
                fontWeight: FontWeight.w400,
                wordSpacing: 0.7 * wm,
              ),
            ),
          ),
        ),
        // SizedBox(height: 1.23 * hm),
      ],
    );
  }

  // List<Widget> getAppBarActions() {
  //   if (multiSelectController.isSelecting && (Var.selectedIndex == 0 || Var.selectedIndex == 4)) {
  //     if (Var.isTrash) {
  //       return [
  //         FlatButton(
  //           child: Text('Restore'),
  //           onPressed: () {},
  //         ),
  //         FlatButton(
  //           child: Text('Delete'),
  //           onPressed: () {},
  //         )
  //       ];
  //     } else {
  //       return [
  //         FlatButton(
  //           child: Text('Trash'),
  //           onPressed: () {},
  //         )
  //       ];
  //     }
  //   }
  //   return [];
  // }
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
  Size get preferredSize => Size.fromHeight(15 * wm);

  @override
  Widget build(BuildContext context) {
    return GFAppBar(
      leading: Padding(
        padding: EdgeInsets.only(
          top: 0.62 * hm,
          bottom: (0.62 * hm),
          left: (1.16 * wm) + wm,
          right: (1.16 * wm) + wm,
        ),
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
      //TODO maybe remove it
      title: Text(
        Var.isTrash ? 'DELETED NOTE' : 'NOTE',
        style: TextStyle(
          fontFamily: 'Abril',
          color: Colors.black,
          fontSize: 2.8 * hm,
          fontWeight: FontWeight.w400,
          wordSpacing: 0.7 * wm,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    );
  }
}

//!!
//!!

//   Future<bool> _saveDocument() {
//     final contents = jsonEncode(widget.zefyrController.document);
//     widget.file.writeAsString(contents).then(
//       (_) {
//         print('file saving name: ${widget.file.path}');
//         return Future.value(true);
//       },
//       onError: (_) {
//         print('Error saving file: ${widget.file.path}');
//         return Future.value(false);
//       },
//     );
//     return Future.value(true);
//   }
// }

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
