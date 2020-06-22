import 'dart:convert';
import 'dart:io';

import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/list_tile/gf_list_tile.dart';
import 'package:getflutter/components/toast/gf_toast.dart';
import 'package:getflutter/getflutter.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/pages/notesView.dart';
import 'package:givnotes/pages/notebookPage.dart';
import 'package:givnotes/pages/aboutUs.dart';
import 'package:givnotes/pages/tagsView.dart';
import 'package:givnotes/utils/home.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:route_transitions/route_transitions.dart';
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
          size: 3.4 * hm,
        ),
        title: Text(title),
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
  final Future<String> localPath;
  final FlareControls controls;
  final File file;

  EndDrawerItems({
    this.titleController,
    this.zefyrController,
    this.localPath,
    this.controls,
    this.file,
  });

  void _saveDocument(BuildContext context) {
    final contents = jsonEncode(zefyrController.document);
    file.writeAsString(contents).then((_) {
      //
      print('file saving name: ${file.path}');
    });
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
          SizedBox(height: 0.5 * hm),
          GFListTile(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.only(left: 5 * wm, right: 5 * wm),
            avatar: Icon(
              icon,
              size: 2.4 * hm,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 1.8 * hm,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(height: 0.5 * hm),
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
            Var.isTrash == false
                ? myEndDrawerListTheme(
                    'Save note',
                    Icons.check,
                    () {
                      final title = titleController.text;

                      if (title.isEmpty) {
                        Navigator.pop(context);
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Can't save empty note. Please add a title!"),
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        controls.play('save');
                        Var.isEditing = false;

                        if (Var.noteMode == NoteMode.Adding) {
                          NotesDB.insertNote({
                            'title': title,
                            'text': zefyrController.document.toPlainText(),
                          });

                          NotesDB.getItemRenameList({
                            'title': title,
                            'text': zefyrController.document.toPlainText(),
                          }).then((value) async {
                            final path = await localPath;
                            await file.rename(path + '/${value[0]['id']}.json');
                          });

                          _saveDocument(context);
                          Navigator.pop(context);

                          //
                        } else if (Var.noteMode == NoteMode.Editing) {
                          NotesDB.updateNote({
                            'id': Var.note['id'],
                            'title': title,
                            'text': zefyrController.document.toPlainText(),
                          });

                          _saveDocument(context);

                          Var.noteMode = NoteMode.Adding;
                          Navigator.pop(context);
                        }
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
                      // Var.isTrash = true;
                      // Var.selectedIndex = 4;

                      Navigator.push(
                        context,
                        PageRouteTransition(
                          builder: (context) => HomePage(),
                          animationType: AnimationType.slide_up,
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
                            // ?? But can't update the file name if lots of entries to be updated
                            _confirmDeleteAlert(context, Var.note['id'], localPath);
                          }
                        : () async {
                            await NotesDB.updateNote({
                              'id': Var.note['id'],
                              'title': titleController.text,
                              'text': zefyrController.document.toPlainText(),
                              'trash': 1,
                            });

                            // setState(() {
                            Var.noteMode = NoteMode.Adding;
                            // Var.isTrash = false;
                            // Var.selectedIndex = 0;
                            // });

                            Navigator.push(
                              context,
                              PageRouteTransition(
                                builder: (context) => HomePage(),
                                animationType: AnimationType.slide_up,
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
        content: Text('Are you sure you permanently want to delte this note?'),
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

              // setState(() {
              Var.noteMode = NoteMode.Adding;
              // Var.isTrash = true;
              // Var.selectedIndex = 4;
              // });

              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteTransition(
                  builder: (context) => HomePage(),
                  animationType: AnimationType.slide_up,
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
