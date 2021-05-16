import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';
import 'package:stringprocess/stringprocess.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/widgets/widgets.dart';

class EditorEndDrawer extends StatelessWidget {
  final Function saveNote;
  final NotesModel note;
  final BuildContext rootCtx;

  EditorEndDrawer({
    this.note,
    this.saveNote,
    @required this.rootCtx,
  });

  final HiveDBServices _dbServices = HiveDBServices();
  final StringProcessor _sp = StringProcessor();

  @override
  Widget build(BuildContext context) {
    final _homeVarStore = BlocProvider.of<HomeCubit>(context);
    final _noteEditStore = BlocProvider.of<NoteStatusCubit>(context);

    return SafeArea(
      child: Container(
        width: 280.w,
        child: Drawer(
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
                      insetPadding: EdgeInsets.all(30.w),
                      // contentPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                      title: Text('Statistics'),
                      content: Container(
                        height: 160.h,
                        width: 335.w,
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
                            SizedBox(height: 10.0.h),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 45.0.h,
                                width: 90.0.w,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0.0,
                                    primary: Colors.grey[200],
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
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
            ),

            //
            _noteEditStore.state.noteMode == NoteMode.Editing
                ? myEndDrawerListTheme(
                    _homeVarStore.state.trash ? 'Delete note' : 'Trash note',
                    CupertinoIcons.delete,
                    _homeVarStore.state.trash
                        ? () async {
                            Navigator.pop(context); //? close the drawer
                            await showDialog(
                              context: context,
                              builder: (context) => GivnotesDialog(
                                title: "Delete Note",
                                mainButtonText: "Delete",
                                message: 'Are you sure to permanently delete this note?',
                                showCancel: true,
                                onTap: () async {
                                  final _noteEditStore = context.read<NoteStatusCubit>();

                                  _dbServices.deleteNote(note.key);
                                  _noteEditStore.updateNoteMode(NoteMode.Adding);

                                  Navigator.pop(context); //? close the dialog
                                  Navigator.pop(rootCtx); //? close the editor page
                                },
                              ),
                            );
                          }
                        : () async {
                            note.trash = !note.trash;
                            await note.save();

                            _noteEditStore.updateNoteMode(NoteMode.Adding);

                            if (Scaffold.of(context).isEndDrawerOpen) Navigator.pop(context);
                            Navigator.pop(context);
                          },
                    context,
                  )
                : SizedBox.shrink(),
          ]),
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
          // SizedBox(height: hm * 2),
          GFListTile(
            padding: EdgeInsets.fromLTRB(10.w, 15.h, 20.w, 15.h),
            margin: EdgeInsets.zero,
            icon: Icon(
              icon,
              size: 20.w,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 18.w,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// _confirmDeleteAlert(context, NotesModel note, HiveDBServices _dbServices) async {
//   await showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         content: Text('Are you sure you permanently want to delete this note?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context), //? Close the dialog
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             child: Text('Delete'),
//             onPressed: () async {
//               final _noteEditStore = context.read<NoteAndSearchCubit>();

//               _dbServices.deleteNote(note.key);
//               _noteEditStore.updateNoteMode(NoteMode.Adding);

//               Navigator.pop(context); //? close the dialog
//               Navigator.pushNamed(context, RouterName.homeRoute);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
