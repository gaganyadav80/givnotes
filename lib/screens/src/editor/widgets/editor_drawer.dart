import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:givnotes/routes.dart';
import 'package:stringprocess/stringprocess.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/cubit/note_search_cubit/note_search_cubit.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/global/size_utils.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/screens/screens.dart';

class EditorEndDrawer extends StatelessWidget {
  final Function saveNote;
  final NotesModel note;

  EditorEndDrawer({
    this.note,
    this.saveNote,
  });

  final HiveDBServices _dbServices = HiveDBServices();
  final StringProcessor _sp = StringProcessor();

  final hm = 7.6;
  final wm = 3.94;

  @override
  Widget build(BuildContext context) {
    final _homeVarStore = BlocProvider.of<HomeCubit>(context);
    final _noteEditStore = BlocProvider.of<NoteAndSearchCubit>(context);

    return Container(
      // width: wm * 65,
      width: 0.65 * screenSize.width,
      child: Drawer(
        elevation: 40,
        child: PreferencePage([
          // PreferenceTitle('Options'),
          _homeVarStore.state.trash == false
              ? myEndDrawerListTheme(
                  'Save note',
                  Icons.save_alt,
                  () async {
                    Navigator.pop(context);

                    saveNote(isDrawerSave: true);
                  },
                  context,
                  screenSize,
                )
              : myEndDrawerListTheme(
                  'Restore note',
                  Icons.arrow_upward,
                  () async {
                    note.trash = !note.trash;
                    await note.save();

                    _noteEditStore.updateNoteMode(NoteMode.Adding);

                    if (Scaffold.of(context).isEndDrawerOpen) Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  context,
                  screenSize,
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
                      // height: 160,
                      height: 0.210526316 * screenSize.height,
                      width: (screenSize.width * 0.85),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Words: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("${_sp.getWordCount(note.text)}"),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Characters (With Spaces): ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("${note.text.length}"),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Lines: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("${_sp.getLineCount(note.text)}"),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Paragraphs: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("${note.text.split(".\n\n").length}"),
                            ],
                          ),
                          // SizedBox(height: 10.0),
                          SizedBox(height: 0.013157895 * screenSize.height),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              // height: 45.0,
                              // width: 90.0,
                              height: 0.059210526 * screenSize.height,
                              width: 0.228426396 * screenSize.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  primary: Colors.grey[200],
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'OKAY',
                                  style: TextStyle(
                                    color: Color(0xff1F1F1F),
                                    fontWeight: FontWeight.w600,
                                    // letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // actions: [
                    //   FlatButton(
                    //     onPressed: () => Navigator.pop(context),
                    //     child: Text('OK'),
                    //   ),
                    // ],
                  );
                },
              );
            },
            context,
            screenSize,
          ),

          //
          _noteEditStore.state.noteMode == NoteMode.Editing
              ? myEndDrawerListTheme(
                  _homeVarStore.state.trash ? 'Delete note' : 'Trash note',
                  CupertinoIcons.delete,
                  _homeVarStore.state.trash
                      ? () async {
                          Navigator.pop(context); //? close the drawer
                          await _confirmDeleteAlert(context, note, _dbServices);
                          // Navigator.pop(context); //TODO problem
                          // Navigator.pop(context);
                        }
                      : () async {
                          note.trash = !note.trash;
                          await note.save();

                          _noteEditStore.updateNoteMode(NoteMode.Adding);

                          if (Scaffold.of(context).isEndDrawerOpen) Navigator.pop(context);
                          Navigator.pop(context);
                        },
                  context,
                  screenSize,
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
    Size screenSize,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          // SizedBox(height: hm * 2),
          GFListTile(
            // padding: EdgeInsets.fromLTRB(10, 15, 20, 15),
            padding: EdgeInsets.fromLTRB(
              0.025380711 * screenSize.width,
              0.019736842 * screenSize.height,
              0.050761421 * screenSize.width,
              0.019736842 * screenSize.height,
            ),
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
        ],
      ),
    );
  }

  void showSnackBar(BuildContext context, String msg) {
    Toast.show(msg, context);
  }
}

_confirmDeleteAlert(context, NotesModel note, HiveDBServices _dbServices) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text('Are you sure you permanently want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), //? Close the dialog
            child: Text('Cancel'),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () async {
              final _noteEditStore = context.read<NoteAndSearchCubit>();

              _dbServices.deleteNote(note.key);
              _noteEditStore.updateNoteMode(NoteMode.Adding);

              Navigator.pop(context); //? close the dialog
              Navigator.pushNamed(context, RouterName.homeRoute);
            },
          ),
        ],
      );
    },
  );
}
