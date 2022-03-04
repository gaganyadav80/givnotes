import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/screens/src/notes/src/notes_model.dart';
import 'package:givnotes/screens/src/notes/src/notes_repository.dart';
import 'package:givnotes/services/services.dart';
import 'package:givnotes/widgets/widgets.dart';

class EditorEndDrawer extends StatelessWidget {
  final Function? saveNote;
  final NotesModel? note;
  final BuildContext rootCtx;
  final bool isTrash;

  EditorEndDrawer({
    Key? key,
    this.note,
    this.saveNote,
    required this.rootCtx,
    this.isTrash = false,
  }) : super(key: key);

  // final HiveDBServices _dbServices = HiveDBServices();
  final StringProcessor _sp = StringProcessor();

  @override
  Widget build(BuildContext context) {
    final _noteEditStore = BlocProvider.of<NoteStatusCubit>(context);

    return SafeArea(
      child: SizedBox(
        width: 280.w,
        child: Drawer(
          child: PreferencePage([
            // PreferenceTitle('Options'),
            isTrash == false
                ? myEndDrawerListTheme(
                    'Save note',
                    Icons.save_alt,
                    () async {
                      Navigator.pop(context);

                      saveNote!(isDrawerSave: true);
                    },
                    context,
                  )
                : myEndDrawerListTheme(
                    'Restore note',
                    Icons.arrow_upward,
                    () async {
                      // note.trash = !note.trash;
                      Get.find<NotesController>()
                          .updateNote(note!.copyWith(trash: false));

                      _noteEditStore.updateNoteMode(NoteMode.adding);

                      if (Scaffold.of(context).isEndDrawerOpen) {
                        Navigator.pop(context);
                      }
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      title: const Text('Statistics'),
                      content: SizedBox(
                        height: 160.h,
                        width: 335.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Words: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("${_sp.getWordCount(note!.text!)}"),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Characters (With Spaces): ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("${note!.text!.length}"),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Lines: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("${_sp.getLineCount(note!.text!)}"),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Paragraphs: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("${note!.text!.split(".\n\n").length}"),
                              ],
                            ),
                            SizedBox(height: 10.0.h),
                            Align(
                              alignment: Alignment.topRight,
                              child: SizedBox(
                                height: 45.0.h,
                                width: 90.0.w,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0.0,
                                    primary: Colors.grey[200],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.r)),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
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
            _noteEditStore.state.noteMode == NoteMode.editing
                ? myEndDrawerListTheme(
                    isTrash ? 'Delete note' : 'Trash note',
                    CupertinoIcons.delete,
                    isTrash
                        ? () async {
                            Navigator.pop(context); //? close the drawer
                            await showDialog(
                              context: context,
                              builder: (context) => GivnotesDialog(
                                title: "Delete Note",
                                mainButtonText: "Delete",
                                message:
                                    'Are you sure to permanently delete this note?',
                                showCancel: true,
                                onTap: () async {
                                  final _noteEditStore =
                                      context.read<NoteStatusCubit>();

                                  // _dbServices.deleteNote(note.key);
                                  Get.find<NotesController>()
                                      .deleteNote(note!.id);
                                  _noteEditStore
                                      .updateNoteMode(NoteMode.adding);

                                  Navigator.pop(context); //? close the dialog
                                  Navigator.pop(
                                      rootCtx); //? close the editor page
                                },
                              ),
                            );
                          }
                        : () async {
                            Get.find<NotesController>()
                                .updateNote(note!.copyWith(trash: true));

                            _noteEditStore.updateNoteMode(NoteMode.adding);

                            if (Scaffold.of(context).isEndDrawerOpen) {
                              Navigator.pop(context);
                            }
                            Navigator.pop(context);
                          },
                    context,
                  )
                : const SizedBox.shrink(),
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
      onTap: onPressed as void Function()?,
      child: Column(
        children: [
          GFListTile(
            padding: EdgeInsets.fromLTRB(10.w, 15.h, 20.w, 15.h),
            margin: EdgeInsets.zero,
            icon: Icon(icon, size: 20.w),
            title: title.text.size(18.w).light.make(),
          ),
        ],
      ),
    );
  }
}
