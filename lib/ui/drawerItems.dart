import 'dart:convert';

import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:givnotes/database/HiveDB.dart';
import 'package:givnotes/database/hive_db_helper.dart';
import 'package:givnotes/packages/toast.dart';
import 'package:givnotes/packages/zefyr-1.0.0/zefyr.dart';
import 'package:givnotes/pages/home.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/variables/prefs.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:morpheus/morpheus.dart';
import 'package:preferences/preferences.dart';
import 'package:stringprocess/stringprocess.dart';

class DrawerItems extends StatefulWidget {
  DrawerItems({Key key, this.rebuildHome}) : super(key: key);

  final Function rebuildHome;

  @override
  _DrawerItemsState createState() => _DrawerItemsState();
}

class _DrawerItemsState extends State<DrawerItems> {
  final List<IconData> _icons = [
    CupertinoIcons.book,
    null,
    CupertinoIcons.bookmark,
    null,
    CupertinoIcons.delete,
    CupertinoIcons.person,
    CupertinoIcons.settings,
  ];

  Widget myListTileTheme(String title, int index, BuildContext context) {
    return ListTileTheme(
      selectedColor: Colors.teal,
      child: ListTile(
        selected: Var.selectedIndex == index ? true : false,
        leading: Icon(
          _icons[index],
          size: 7 * wm,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 5 * wm,
            fontWeight: FontWeight.w300,
          ),
        ),
        onTap: () {
          if (index == 4)
            Var.isTrash = true;
          else
            Var.isTrash = false;

          Var.selectedIndex = index;
          Navigator.pop(context);
          widget.rebuildHome();
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
          myListTileTheme('All Notes', 0, context), // NotesView(isTrash: false)
          myListTileTheme('Tags', 2, context), // TagsView()
          myListTileTheme('Trash', 4, context), // NotesView(isTrash: true)
          myListTileTheme('Configuration', 6, context),
          myListTileTheme('About Us', 5, context), // AboutUs()
        ],
      ),
    );
  }
}

// ! End Drawer
class EndDrawerItems extends StatefulWidget {
  final TextEditingController titleController;
  final ZefyrController zefyrController;
  final Function updateZefyrEditMode;
  final FlareControls controls;
  final NotesModel note;
  final int noteIndex;

  final Map<String, int> noteTagsMap;

  EndDrawerItems({this.updateZefyrEditMode, this.titleController, this.zefyrController, this.controls, this.note, this.noteTagsMap, this.noteIndex});

  @override
  _EndDrawerItemsState createState() => _EndDrawerItemsState();
}

class _EndDrawerItemsState extends State<EndDrawerItems> {
  final HiveDBServices _dbServices = HiveDBServices();
  final StringProcessor _sp = StringProcessor();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wm * 65,
      child: Drawer(
        elevation: 40,
        child: PreferencePage([
          PreferenceTitle('Options'),
          Var.isTrash == false
              ? myEndDrawerListTheme(
                  'Save note',
                  Icons.save_alt,
                  () async {
                    Navigator.pop(context);

                    if (Var.isEditing == false) {
                      //
                      // Var.noteMode = NoteMode.Adding;
                      // Navigator.pop(context);
                      //
                    } else if (Var.isEditing) {
                      String _title = widget.titleController.text;
                      String _text = widget.zefyrController.document.toPlainText().trim();

                      if (_title.isEmpty && _text.isEmpty) {
                        //
                        FocusScope.of(context).unfocus();
                        showToast(context, "Can't create empty note");
                        Navigator.pop(context);
                        Var.isEditing = false;
                        //
                      } else {
                        //
                        FocusScope.of(context).unfocus();
                        widget.controls.play('save');
                        // controls.play('idle-arrow');
                        widget.updateZefyrEditMode(false);

                        if (Var.noteMode == NoteMode.Adding) {
                          await _dbServices.insertNote(
                            NotesModel()
                              ..title = _title.isNotEmpty ? _title : 'Untitled'
                              ..text = _text
                              ..znote = jsonEncode(widget.zefyrController.document)
                              ..created = DateTime.now()
                              ..modified = DateTime.now()
                              ..tagsMap = widget.noteTagsMap,
                            // ..tags = noteTags
                            // ..tagColor = noteTagColors,
                          );

                          showToast(context, 'Note saved');
                          //
                        } else if (Var.noteMode == NoteMode.Editing) {
                          await _dbServices.updateNote(
                            widget.noteIndex,
                            NotesModel()
                              ..title = _title.isNotEmpty ? _title : 'Untitled'
                              ..text = _text
                              ..znote = jsonEncode(widget.zefyrController.document)
                              ..trash = widget.note.trash
                              ..created = widget.note.created
                              ..modified = DateTime.now()
                              ..tagsMap = widget.noteTagsMap,
                            // ..tags = noteTags
                            // ..tagColor = noteTagColors,
                          );

                          showToast(context, 'Note saved');
                        }
                      }
                    }
                  },
                  context,
                )
              : myEndDrawerListTheme(
                  'Restore note',
                  Icons.arrow_upward,
                  () async {
                    widget.note.trash = !widget.note.trash;
                    await widget.note.save();

                    Var.noteMode = NoteMode.Adding;

                    if (Scaffold.of(context).isEndDrawerOpen) Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  context,
                ),

          myEndDrawerListTheme(
            'Statistics',
            CupertinoIcons.info,
            () async {
              Navigator.pop(context);

              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    insetPadding: EdgeInsets.all(30),
                    // contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    title: Text('Statistics'),
                    content: Container(
                      height: 80,
                      width: (wm * 100) - 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Words: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("${_sp.getWordCount(widget.note.text)}"),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Characters (With Spaces): ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("${widget.note.text.length}"),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Lines: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("${_sp.getLineCount(widget.note.text)}"),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Paragraphs: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("${widget.note.text.split(".\n\n").length}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            context,
          ),

          //
          Var.noteMode == NoteMode.Editing
              ? myEndDrawerListTheme(
                  Var.isTrash ? 'Delete note' : 'Trash note',
                  CupertinoIcons.delete,
                  Var.isTrash
                      ? () async {
                          Navigator.pop(context); //? close the drawer
                          await _confirmDeleteAlert(context, widget.note, _dbServices);
                          // Navigator.pop(context); //TODO problem
                          // Navigator.pop(context);
                        }
                      : () async {
                          widget.note.trash = !widget.note.trash;
                          await widget.note.save();

                          Var.noteMode = NoteMode.Adding;

                          if (Scaffold.of(context).isEndDrawerOpen) Navigator.pop(context);
                          Navigator.pop(context);
                        },
                  context,
                )
              : SizedBox.shrink(),
        ]),
      ),
    );
  }

  Widget myEndDrawerListTheme(
    String title,
    IconData icon,
    Function onPressed,
    BuildContext context,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          // SizedBox(height: hm * 2),
          GFListTile(
            padding: EdgeInsets.fromLTRB(10, 15, 20, 15),
            margin: EdgeInsets.zero,
            icon: Icon(
              icon,
              size: 5 * wm,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 4.5 * wm,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          // SizedBox(height: hm * 2),
          // Divider(
          //   thickness: 0.01 * hm,
          //   height: 0.01 * hm,
          //   color: Colors.black,
          //   indent: 6.5 * wm,
          //   endIndent: 4 * wm,
          // ),
        ],
      ),
    );
  }

  void showToast(BuildContext context, String msg) {
    Toast.show(
      msg,
      context,
      duration: 3,
      gravity: Toast.BOTTOM,
      backgroundColor: toastGrey,
      backgroundRadius: 5,
    );
  }
}

_confirmDeleteAlert(context, NotesModel note, HiveDBServices _dbServices) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text('Are you sure you permanently want to delete this note?'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context), //? Close the dialog
            child: Text('Cancle'),
          ),
          FlatButton(
            child: Text('Delete'),
            onPressed: () async {
              _dbServices.deleteNote(note.key);
              Var.noteMode = NoteMode.Adding;

              Navigator.pop(context); //? close the dialog
              Navigator.push(
                context,
                MorpheusPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
