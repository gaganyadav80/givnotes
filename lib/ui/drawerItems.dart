import 'dart:convert';

import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/variables/prefs.dart';
import 'package:givnotes/pages/home.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:intl/intl.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:toast/toast.dart';
import 'package:zefyr/zefyr.dart';

class DrawerItems extends StatelessWidget {
  final List<IconData> _icons = [
    CupertinoIcons.book,
    null,
    CupertinoIcons.bookmark,
    null,
    CupertinoIcons.delete,
    CupertinoIcons.person,
    CupertinoIcons.settings,
    // CupertinoIcons.folder,
  ];

  Widget myListTileTheme(String title, int index, BuildContext context) {
    return ListTileTheme(
      // selectedColor: Color(0xffEC625C),
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
          Navigator.push(
            context,
            MorpheusPageRoute(
              builder: (context) => HomePage(),
              // animationType: AnimationType.scale,
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
          myListTileTheme('All Notes', 0, context), // NotesView(isTrash: false)
          // myListTileTheme('Notebooks', 7, context), //  Notebooks()
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
  // final Future<String> localPath;
  final FlareControls controls;
  // final File file;

  EndDrawerItems({
    this.updateZefyrEditMode,
    this.titleController,
    this.zefyrController,
    // this.localPath,
    this.controls,
    // this.file,
  });

  // Future<bool> _saveDocument(BuildContext context) {
  //   final contents = jsonEncode(zefyrController.document);
  //   file.writeAsString(contents).then(
  //     (_) {
  //       print('file saving name: ${file.path}');
  //       return Future.value(true);
  //     },
  //     onError: () {
  //       print('Error saving file: ${file.path}');
  //       return Future.value(false);
  //     },
  //   );
  //   return Future.value(true);
  // }

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
                          MorpheusPageRoute(
                            builder: (context) => HomePage(),
                            // animationType: AnimationType.fade,
                          ),
                        );
                        //
                      } else if (Var.isEditing) {
                        String title = titleController.text;
                        String note = zefyrController.document.toPlainText().trim();

                        if (title.isEmpty && note.isEmpty) {
                          //
                          FocusScope.of(context).unfocus();
                          showToast(
                            context,
                            "Can't create empty note",
                          );
                          //! Only close the drawer
                          Navigator.pop(context);
                          // Navigator.pop(context);
                          //
                        } else {
                          //
                          String time;
                          FocusScope.of(context).unfocus();
                          controls.play('save');
                          updateZefyrEditMode(false);
                          // Var.isEditing = false;

                          if (Var.noteMode == NoteMode.Adding) {
                            time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

                            if (title.isEmpty) title = 'Untitled';

                            NotesDB.insertNote({
                              'title': title,
                              'text': zefyrController.document.toPlainText(),
                              'znote': jsonEncode(zefyrController.document),
                              'created': time,
                              'modified': time,
                            });

                            showToast(context, 'Note saved');
                            Navigator.pop(context);

                            if (!prefsBox.containsKey('searchList')) {
                              prefsBox.put('searchList', []);
                            }
                            final List<dynamic> list = (prefsBox.get('searchList') as List).cast<String>();
                            list.add(title + ' ' + note);
                            prefsBox.put('searchList', list);

                            // NotesDB.getItemToRename({
                            //   'title': title,
                            //   'text': zefyrController.document.toPlainText(),
                            //   'created': time,
                            // }).then((value) async {
                            //   final path = (await getApplicationDocumentsDirectory()).path;
                            //   await file.rename(path + '/${value[0]['id']}.json');
                            // });

                            // _saveDocument(context).then((value) {
                            //   showToast(
                            //     context,
                            //     value ? 'Note saved...' : 'Ops! Error saving :(',
                            //   );
                            // });
                            //
                          } else if (Var.noteMode == NoteMode.Editing) {
                            // file.lastModified().then((value) {
                            //   time = DateFormat('yyyy-MM-dd HH:mm:ss').format(value);
                            // });
                            time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
                            NotesDB.updateNote({
                              'id': Var.note['id'],
                              'title': title,
                              'text': zefyrController.document.toPlainText(),
                              'znote': jsonEncode(zefyrController.document),
                              'modified': time,
                            });

                            showToast(context, 'Note saved');
                            Navigator.pop(context);

                            // _saveDocument(context).then((value) {
                            //   showToast(
                            //     context,
                            //     value ? 'Note saved...' : 'Ops! Error saving :(',
                            //   );
                            // });
                          }
                        }
                        // Var.isEditing = false;
                      }
                    },
                    context,
                  )
                : myEndDrawerListTheme(
                    'Restore note',
                    Icons.arrow_upward,
                    () async {
                      //! Check this
                      await NotesDB.updateNote({
                        'id': Var.note['id'],
                        // 'title': titleController.text,
                        // 'text': zefyrController.document.toPlainText(),
                        'trash': 0,
                      });

                      Var.noteMode = NoteMode.Adding;

                      Navigator.push(
                        context,
                        MorpheusPageRoute(
                          builder: (context) => HomePage(),
                          // animationType: AnimationType.slide_left,
                        ),
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
                        ? () {
                            Navigator.pop(context);
                            _confirmDeleteAlert(context, Var.note['id']);
                          }
                        : () async {
                            //! this check laso ucfk uoy
                            await NotesDB.updateNote({
                              'id': Var.note['id'],
                              // 'title': titleController.text,
                              // 'text': zefyrController.document.toPlainText(),
                              'trash': 1,
                            });

                            Var.noteMode = NoteMode.Adding;

                            Navigator.push(
                              context,
                              MorpheusPageRoute(
                                builder: (context) => HomePage(),
                                // animationType: AnimationType.slide_left,
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

_confirmDeleteAlert(context, int _id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // title: Text('Confirm Delete!'),
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
              // final path = (await getApplicationDocumentsDirectory()).path;
              // final file = File(path + "/$_id.json");
              // file.delete();

              Var.noteMode = NoteMode.Adding;

              Navigator.pop(context);
              Navigator.push(
                context,
                MorpheusPageRoute(
                  builder: (context) => HomePage(),
                  // animationType: AnimationType.fade,
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
