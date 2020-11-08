import 'dart:convert';

import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:givnotes/database/HiveDB.dart';
import 'package:givnotes/database/hive_db_helper.dart';
import 'package:givnotes/packages/toast.dart';
import 'package:givnotes/packages/zefyr-1.0.0/zefyr.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/variables/prefs.dart';
import 'package:givnotes/pages/zefyrEdit.dart';

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
class EndDrawerItems extends StatelessWidget {
  final TextEditingController titleController;
  final ZefyrController zefyrController;
  final Function updateZefyrEditMode;
  final FlareControls controls;
  final NotesModel note;

  final Map<String, int> noteTagsMap;
  // List<String> noteTags = <String>[];
  // List<int> noteTagColors = [];

  final HiveDBServices _dbServices = HiveDBServices();

  EndDrawerItems({
    this.updateZefyrEditMode,
    this.titleController,
    this.zefyrController,
    this.controls,
    this.note,
    this.noteTagsMap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        elevation: 40,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.black,
              height: 25 * hm,
              child: Center(
                child: Text(
                  "Notes context menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 3.5 * hm,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            Var.isTrash == false
                ? myEndDrawerListTheme(
                    'Save note',
                    Icons.check,
                    () async {
                      if (Var.isEditing == false) {
                        //
                        Var.noteMode = NoteMode.Adding;
                        Navigator.pop(context);
                        //
                      } else if (Var.isEditing) {
                        String _title = titleController.text;
                        String _note = zefyrController.document.toPlainText().trim();

                        if (_title.isEmpty && _note.isEmpty) {
                          //
                          FocusScope.of(context).unfocus();
                          showToast(context, "Can't create empty note");
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Var.isEditing = false;
                          //
                        } else {
                          //
                          FocusScope.of(context).unfocus();
                          controls.play('save');
                          // controls.play('idle-arrow');
                          updateZefyrEditMode(false);

                          if (Var.noteMode == NoteMode.Adding) {
                            await _dbServices.insertNote(
                              NotesModel()
                                ..title = _title.isNotEmpty ? _title : 'Untitled'
                                ..text = _note
                                ..znote = jsonEncode(zefyrController.document)
                                ..created = DateTime.now()
                                ..modified = DateTime.now()
                                ..tagsMap = noteTagsMap,
                              // ..tags = noteTags
                              // ..tagColor = noteTagColors,
                            );

                            showToast(context, 'Note saved');
                            //
                          } else if (Var.noteMode == NoteMode.Editing) {
                            await _dbServices.updateNote(
                              note.key,
                              NotesModel()
                                ..title = _title.isNotEmpty ? _title : 'Untitled'
                                ..text = _note
                                ..znote = jsonEncode(zefyrController.document)
                                ..trash = note.trash
                                ..created = note.created
                                ..modified = DateTime.now()
                                ..tagsMap = noteTagsMap,
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
                      note.trash = !note.trash;
                      await note.save();

                      Var.noteMode = NoteMode.Adding;

                      if (Scaffold.of(context).isEndDrawerOpen) Navigator.pop(context);
                      Navigator.pop(context);
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
                            Navigator.pop(context);
                            await _confirmDeleteAlert(context, note, _dbServices);
                            Navigator.pop(context);
                          }
                        : () async {
                            note.trash = !note.trash;
                            await note.save();

                            Var.noteMode = NoteMode.Adding;

                            if (Scaffold.of(context).isEndDrawerOpen) Navigator.pop(context);
                            Navigator.pop(context);
                          },
                    context,
                  )
                : SizedBox.shrink(),
          ],
        ),
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
          SizedBox(height: hm * 2),
          GFListTile(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.only(left: 5 * wm, right: 5 * wm),
            avatar: Icon(
              icon,
              size: 2.7 * hm,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 2.7 * hm,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(height: hm * 2),
          Divider(
            thickness: 0.01 * hm,
            height: 0.01 * hm,
            color: Colors.black,
            indent: 6.5 * wm,
            endIndent: 4 * wm,
          ),
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
            onPressed: () => Navigator.pop(context),
            child: Text('Cancle'),
          ),
          FlatButton(
            child: Text('Delete'),
            onPressed: () async {
              _dbServices.deleteNote(note.key);

              // final List<String> list = (prefsBox.get('searchList') as List).cast<String>();
              // list.remove(note.title + ' ' + note.text.trim());
              // prefsBox.put('searchList', list);

              Var.noteMode = NoteMode.Adding;

              Navigator.pop(context);
              // Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
