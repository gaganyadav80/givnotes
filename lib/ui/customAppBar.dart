import 'dart:convert';
import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/utils/home.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:intl/intl.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:toast/toast.dart';
import 'package:zefyr/zefyr.dart';

// ! Simple AppBar
class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  final Function updateZefyrEditMode;
  final String title;
  final FlareControls controls;
  final bool isNote;
  final TextEditingController titleController;
  final ZefyrController zefyrController;
  final Future<String> localPath;
  final File file;

  MyAppBar(
    this.title, {
    this.isNote,
    this.controls,
    this.titleController,
    this.zefyrController,
    this.localPath,
    this.file,
    this.updateZefyrEditMode,
  });

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(14 * hm);
}

class _MyAppBarState extends State<MyAppBar> {
  String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //TODO: remove this heights
        SizedBox(height: 1.23 * hm),
        GFAppBar(
          leading: leading(context),
          actions: [
            widget.isNote
                ? IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  )
                : SizedBox.shrink(),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        Padding(
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
        SizedBox(height: 1.23 * hm),
      ],
    );
  }

  Widget leading(BuildContext context) {
    if (widget.isNote == true) {
      return Padding(
        padding: EdgeInsets.only(
          top: 0.62 * hm,
          bottom: (0.62 * hm) + hm,
          left: (1.16 * wm) + wm,
          right: (1.16 * wm) + wm,
        ),
        child: InkWell(
          onTap: () {
            if (Var.isEditing == false) {
              //
              Var.noteMode = NoteMode.Adding;
              Navigator.push(
                context,
                PageRouteTransition(
                  builder: (context) => HomePage(),
                  animationType: AnimationType.fade,
                ),
              );
              //
            } else if (Var.isEditing) {
              String title = widget.titleController.text;
              String note = widget.zefyrController.document.toPlainText().trim();

              if (title.isEmpty && note.isEmpty) {
                //
                Toast.show(
                  "Can't create empty note.",
                  context,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.BOTTOM,
                  backgroundRadius: 5,
                );
                Navigator.pop(context);
                //
              } else {
                //
                widget.controls.play('save');
                widget.updateZefyrEditMode(false);

                if (Var.noteMode == NoteMode.Adding) {
                  //
                  time = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
                  //
                  if (title.isEmpty) title = 'Untitled';
                  NotesDB.insertNote({
                    'title': title,
                    'text': widget.zefyrController.document.toPlainText(),
                    'created': time,
                    'modified': time,
                  });

                  NotesDB.getItemToRename({
                    'title': title,
                    'text': widget.zefyrController.document.toPlainText(),
                    'created': time,
                  }).then((value) async {
                    final path = await widget.localPath;
                    await widget.file.rename(path + '/${value[0]['id']}.json');
                  });

                  _saveDocument(context).then((value) {
                    Toast.show(
                      value ? 'Note saved...' : 'Ops! Error saving :(',
                      context,
                      duration: 10,
                      gravity: Toast.BOTTOM,
                      backgroundRadius: 5,
                    );
                  });

                  //
                } else if (Var.noteMode == NoteMode.Editing) {
                  //
                  time = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
                  //
                  NotesDB.updateNote({
                    'id': Var.note['id'],
                    'title': title,
                    'text': widget.zefyrController.document.toPlainText(),
                    'modified': time,
                  });

                  _saveDocument(context).then((value) {
                    Toast.show(
                      value ? 'Note saved...' : 'Ops! Error saving :(',
                      context,
                      duration: 10,
                      gravity: Toast.BOTTOM,
                      backgroundRadius: 5,
                    );
                  });
                }
              }
              Var.isEditing = false;
            }
          },
          child: FlareActor(
            'assets/animations/arrow-tick.flr',
            animation: Var.noteMode == NoteMode.Adding ? 'idle-tick' : 'idle-arrow',
            controller: widget.controls,
            alignment: Alignment.center,
            fit: BoxFit.contain,
          ),
        ),
      );
    } else {
      return IconButton(
        icon: Icon(Icons.menu),
        color: Colors.black,
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      );
    }
  }

  Future<bool> _saveDocument(BuildContext context) {
    final contents = jsonEncode(widget.zefyrController.document);
    widget.file.writeAsString(contents).then(
      (_) {
        print('file saving name: ${widget.file.path}');
        return Future.value(true);
      },
      onError: (_) {
        print('Error saving file: ${widget.file.path}');
        return Future.value(false);
      },
    );
    return Future.value(true);
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
