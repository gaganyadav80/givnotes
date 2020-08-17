import 'dart:convert';
import 'dart:io';

import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/pages/notesView.dart';
import 'package:givnotes/pages/notebookPage.dart';
import 'package:givnotes/pages/aboutUs.dart';
import 'package:givnotes/pages/tagsView.dart';
import 'package:givnotes/utils/home.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:toast/toast.dart';
import 'package:zefyr/zefyr.dart';

// ! Drawer
List<IconData> _icons = [
  CupertinoIcons.book,
  null,
  CupertinoIcons.bookmark,
  null,
  trashIcon,
  CupertinoIcons.person,
  CupertinoIcons.settings,
  CupertinoIcons.folder,
];

class DrawerItems extends StatelessWidget {
  Widget myListTileTheme(String title, int index, BuildContext context, [Widget nextPage]) {
    return ListTileTheme(
      selectedColor: Color(0xffEC625C),
      child: ListTile(
        selected: Var.selectedIndex == index ? true : false,
        leading: Icon(
          _icons[index],
          size: 6.5 * wm,
        ),
        title: Text(
          title,
          style: GoogleFonts.ubuntu(
            fontSize: 4 * wm,
          ),
        ),
        onTap: () {
          if (index == 4)
            Var.isTrash = true;
          else
            Var.isTrash = false;

          Var.selectedIndex = index;

          Navigator.pop(context);
          Navigator.push(
            context,
            PageRouteTransition(
              builder: (context) => HomePage(),
              animationType: AnimationType.slide_left,
            ),
          );
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
          myListTileTheme('All Notes', 0, context, NotesView(isTrash: false)),
          myListTileTheme('Notebooks', 7, context, Notebooks()),
          myListTileTheme('Tags', 2, context, TagsView()),
          myListTileTheme('Trash', 4, context, NotesView(isTrash: true)),
          myListTileTheme('Configuration', 6, context),
          myListTileTheme('About Us', 5, context, AboutUs()),
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
  final Future<String> localPath;
  final FlareControls controls;
  final File file;

  EndDrawerItems({
    this.updateZefyrEditMode,
    this.titleController,
    this.zefyrController,
    this.localPath,
    this.controls,
    this.file,
  });

  Future<bool> _saveDocument(BuildContext context) {
    final contents = jsonEncode(zefyrController.document);
    file.writeAsString(contents).then(
      (_) {
        print('file saving name: ${file.path}');
        return Future.value(true);
      },
      onError: () {
        print('Error saving file: ${file.path}');
        return Future.value(false);
      },
    );
    return Future.value(true);
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
            Divider(
              thickness: 0.01 * hm,
              height: 0.01 * hm,
              color: Colors.black,
              indent: 6.5 * wm,
              endIndent: 4 * wm,
            ),
            Var.isTrash == false
                ? myEndDrawerListTheme(
                    'Save note',
                    Icons.check,
                    () {
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
                        String title = titleController.text;
                        String note = zefyrController.document.toPlainText().trim();

                        if (title.isEmpty && note.isEmpty) {
                          //
                          Toast.show(
                            "Can't save empty note. Please add a title!",
                            context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM,
                            backgroundRadius: 5,
                            backgroundColor: Colors.black,
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);
                          //
                        } else {
                          //
                          String time;
                          controls.play('save');
                          updateZefyrEditMode(false);

                          print('isEditing: ${Var.isEditing}');

                          if (Var.noteMode == NoteMode.Adding) {
                            // time = DateFormat('yyyy-MM-dd - kk:mm').format(DateTime.now());
                            time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

                            if (title.isEmpty) title = 'Untitled';
                            NotesDB.insertNote({
                              'title': title,
                              'text': zefyrController.document.toPlainText(),
                              'created': time,
                              'modified': time,
                            });

                            NotesDB.getItemToRename({
                              'title': title,
                              'text': zefyrController.document.toPlainText(),
                              'created': time,
                            }).then((value) async {
                              final path = await localPath;
                              await file.rename(path + '/${value[0]['id']}.json');
                            });

                            _saveDocument(context).then((value) {
                              Toast.show(
                                value ? 'Note saved...' : 'Ops! Error saving :(',
                                context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM,
                                backgroundRadius: 5,
                                backgroundColor: Colors.black,
                              );
                            });
                            //
                          } else if (Var.noteMode == NoteMode.Editing) {
                            file.lastModified().then((value) {
                              time = DateFormat('yyyy-MM-dd HH:mm:ss').format(value);
                            });
                            NotesDB.updateNote({
                              'id': Var.note['id'],
                              'title': title,
                              'text': zefyrController.document.toPlainText(),
                              'modified': time,
                            });

                            _saveDocument(context).then((value) {
                              Toast.show(
                                value ? 'Note saved...' : 'Ops! Error saving :(',
                                context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM,
                                backgroundRadius: 5,
                              );
                            });
                          }
                        }
                        Var.isEditing = false;
                      }
                    },
                    context,
                  )
                : myEndDrawerListTheme(
                    'Restore note',
                    Icons.arrow_upward,
                    () async {
                      await NotesDB.updateNote({
                        'id': Var.note['id'],
                        'title': titleController.text,
                        'text': zefyrController.document.toPlainText(),
                        'trash': 0,
                      });

                      Var.noteMode = NoteMode.Adding;

                      Navigator.push(
                        context,
                        PageRouteTransition(
                          builder: (context) => HomePage(),
                          animationType: AnimationType.slide_left,
                        ),
                      );
                    },
                    context,
                  ),

            //
            Var.noteMode == NoteMode.Editing
                ? myEndDrawerListTheme(
                    Var.isTrash ? 'Delete note' : 'Trash note',
                    trashIcon,
                    Var.isTrash
                        ? () {
                            // TODO: Update the id if inbetween item is deleted
                            // ex. 1->2->3 => (and delete 2) => 1->3 => (then update) => 1->2
                            // But can't update the file name if lots of entries to be updated
                            Navigator.pop(context);
                            _confirmDeleteAlert(context, Var.note['id'], localPath);
                          }
                        : () async {
                            await NotesDB.updateNote({
                              'id': Var.note['id'],
                              'title': titleController.text,
                              'text': zefyrController.document.toPlainText(),
                              'trash': 1,
                            });

                            Var.noteMode = NoteMode.Adding;

                            Navigator.push(
                              context,
                              PageRouteTransition(
                                builder: (context) => HomePage(),
                                animationType: AnimationType.slide_left,
                              ),
                            );
                          },
                    context,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

_confirmDeleteAlert(context, int _id, Future<String> _localPath) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Delete!'),
        content: Text('Are you sure you permanently want to delete this note?'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancle'),
          ),
          FlatButton(
            child: Text('Delete'),
            onPressed: () async {
              await NotesDB.deleteNote(_id);
              final path = await _localPath;
              final file = File(path + "/$_id.json");
              file.delete();

              Var.noteMode = NoteMode.Adding;

              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteTransition(
                  builder: (context) => HomePage(),
                  animationType: AnimationType.fade,
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
