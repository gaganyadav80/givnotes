import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/src/notes/src/notes_model.dart';
import 'package:givnotes/screens/src/notes/src/notes_repository.dart';
import 'package:givnotes/services/services.dart';

import 'widgets/notes_widgets.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key key}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<NotesController>(
          init: NotesController(),
          builder: (NotesController controller) {
            List<NotesModel> _notes = controller.notes.where((element) => element.trash == false).toList();

            if ((_notes.isEmpty)) {
              return NotesEmptyView(isTrash: false);
            }

            return CupertinoScrollbar(
              child: ListView.builder(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final NotesModel note = _notes[index];

                  //TODO redesign notes slidable
                  return Slidable(
                    key: UniqueKey(),
                    actionPane: SlidableBehindActionPane(),
                    actionExtentRatio: 1.0,
                    dismissal: SlidableDismissal(
                      child: SlidableDrawerDismissal(),
                      onDismissed: (actionType) {
                        controller.updateNote(note.copyWith(trash: true));
                        Fluttertoast.showToast(msg: "moved to trash");
                      },
                    ),
                    secondaryActions: <Widget>[
                      iconSlideAction(Color(0xFFDD4C4F), CupertinoIcons.trash, 'TRASH'),
                    ],
                    child: NotesCard(note: note, index: index),
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: BlocBuilder<HomeCubit, int>(
          buildWhen: (previous, current) => previous != current,
          builder: (_, state) {
            return state == 0
                ? Container(
                    height: 65.w,
                    width: 65.w,
                    decoration: BoxDecoration(color: Color(0xFFDD4C4F), shape: BoxShape.circle),
                    child: FloatingActionButton(
                      child: Icon(CupertinoIcons.pencil_outline, color: Colors.white),
                      backgroundColor: Color(0xFFDD4C4F),
                      onPressed: () async {
                        await HandlePermission.requestPermission().then((value) async {
                          if (value) {
                            BlocProvider.of<NoteStatusCubit>(context).updateIsEditing(true);
                            BlocProvider.of<NoteStatusCubit>(context).updateNoteMode(NoteMode.Adding);
                            Navigator.pushNamed(
                              context,
                              RouterName.editorRoute,
                              arguments: [NoteMode.Adding, null],
                            );
                          } else {
                            if (isPermanentDisabled) {
                              HandlePermission.permanentDisabled(context);
                            }
                          }
                        });
                      },
                    ),
                  )
                : SizedBox.shrink();
          },
        ),
      ),
    );
  }

  IconSlideAction iconSlideAction(Color color, IconData icon, String caption) {
    return IconSlideAction(
      color: color,
      iconWidget: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 40.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white.withOpacity(0.9)),
                SizedBox(height: 15.0.w),
                Text(caption, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
              ],
            ),
          )
        ],
      ),
      onTap: () => print('moved to Trash'),
    );
  }
}

//? Test notes view with GetBuilder + json
// class NotesViewGetBuilder extends StatefulWidget {
//   NotesViewGetBuilder({Key key}) : super(key: key);

//   @override
//   _NotesViewGetBuilderState createState() => _NotesViewGetBuilderState();
// }

// class _NotesViewGetBuilderState extends State<NotesViewGetBuilder> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GetBuilder<NotesController>(
//         init: NotesController(),
//         builder: (controller) {
//           if (controller.notes.length == 0) {
//             return NotesEmptyView(isTrash: false);
//           }

//           return CupertinoScrollbar(
//             child: ListView.builder(
//               physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//               itemCount: controller.notes.length,
//               itemBuilder: (context, index) {
//                 index = controller.notes.length - index - 1;

//                 final NotesModel note = controller.notes[index];

//                 return InkWell(
//                   onLongPress: () {
//                     controller.deleteNote(note.id, index);
//                   },
//                   child: Card(
//                     elevation: 5.w,
//                     margin: EdgeInsets.all(10.w),
//                     child: <Widget>[
//                       note.id.text.italic.make(),
//                       note.title.text.make(),
//                       note.text.text.make(),
//                       note.trash.toString().text.make(),
//                       note.znote.text.make(),
//                       note.created.text.make(),
//                       note.modified.text.make(),
//                       note.tags.toString().text.make(),
//                     ].vStack(),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: BlocBuilder<HomeCubit, HomeState>(
//         buildWhen: (previous, current) => previous != current,
//         builder: (context, state) {
//           return state.trash == false && state.index == 0
//               ? Container(
//                   height: 65.w,
//                   width: 65.w,
//                   decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
//                   child: FloatingActionButton(
//                     child: Icon(CupertinoIcons.pencil_outline, color: Colors.white),
//                     backgroundColor: Colors.black,
//                     onPressed: () {
//                       for (int x = 0; x < 648; x++)
//                         Get.find<NotesController>().addNewNote(NotesModel(
//                           title: '_titleController.text.encrypt',
//                           text: '_textController.text.encrypt',
//                           znote: 'jsonEncode(_quillController.toDelta().toJson()).encrypt',
//                           trash: false,
//                           created: '${DateTime.now().toString()}',
//                           modified: '${DateTime.now()}',
//                           tags: <String>['TAG_1', 'TAG_2', 'TAG_3'],
//                         ));

//                       // Fluttertoast.showToast(msg: 'JSON note added');
//                     },
//                   ),
//                 )
//               : SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }

//? Notes View with Hive DB
// ValueListenableBuilder(
//   valueListenable: Hive.box<NotesModel>('givnotes').listenable(),
//   builder: (BuildContext context, Box<NotesModel> box, Widget widget) {
//     _notes = box.values.where((element) => element.trash == homeState.trash).toList();

//     if ((box.isEmpty || _notes.length == 0)) {
//       return NotesEmptyView(isTrash: homeState.trash);
//     }

//     return BlocBuilder<HydratedPrefsCubit, HydratedPrefsState>(
//       builder: (context, prefState) {
//         return CupertinoScrollbar(
//           child: ListView.builder(
//             physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//             itemCount: _notes.length,
//             itemBuilder: (context, index) {
//               sortNotes = prefState.sortBy;

//               if (sortNotes == 0)
//                 _notes.sort((a, b) => a.created.compareTo(b.created));
//               else if (sortNotes == 1)
//                 _notes.sort((a, b) => a.modified.compareTo(b.modified));
//               else if (sortNotes == 2)
//                 _notes.sort((a, b) => b.title.compareTo(a.title));
//               else if (sortNotes == 3) {
//                 _notes.sort((a, b) => a.title.compareTo(b.title));
//               } else
//                 _notes.sort((a, b) => a.created.compareTo(b.created));

//               index = _notes.length - index - 1;

//               final NotesModel note = _notes[index];

//               return Slidable(
//                 key: UniqueKey(),
//                 actionPane: SlidableBehindActionPane(),
//                 actionExtentRatio: 1.0,
//                 dismissal: SlidableDismissal(
//                   child: SlidableDrawerDismissal(),
//                   onDismissed: (actionType) {
//                     if (!homeState.trash) {
//                       note.trash = !note.trash;
//                       note.save();

//                       Fluttertoast.showToast(msg: "moved to trash");
//                     } else {
//                       note.trash = false;
//                       note.save();

//                       Fluttertoast.showToast(msg: "moved to notes");
//                     }
//                   },
//                 ),
//                 secondaryActions: <Widget>[
//                   !homeState.trash
//                       ? iconSlideAction(Color(0xFFDD4C4F), CupertinoIcons.trash, 'TRASH')
//                       : iconSlideAction(
//                           Color(0xFF82C8F6),
//                           CupertinoIcons.arrow_up_bin,
//                           'RESTORE',
//                         ),
//                 ],
//                 child: NotesCard(
//                   note: note,
//                   index: index,
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   },
// );

//? Notes View with folder Watcher
// class NotesViewWatcher extends StatefulWidget {
//   NotesViewWatcher({Key key}) : super(key: key);

//   @override
//   _NotesViewWatcherState createState() => _NotesViewWatcherState();
// }

// class _NotesViewWatcherState extends State<NotesViewWatcher> {
//   Directory dir =
//       Directory("/data/user/0/com.gaganyadav.givnotes/app_flutter/givnotesdb/${FirebaseAuth.instance.currentUser.uid}/")
//         ..createSync(recursive: true);

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       body: StreamBuilder<WatchEvent>(
//         stream: DirectoryWatcher(dir.path).events,
//         builder: (context, snapshot) {
//           var notes = dir
//               .listSync()
//               .map((e) => LocalNotesModel.fromJson(json.decode(File(e.path).readAsStringSync())))
//               .toList();

//           notes.sort((a, b) => b.created.compareTo(a.created));

//           // Rebuild 6 times per 100 simultaneous entries;
//           // Have to maintain only one list;
//           // But it will fetch and get the while list
//           print("================= REBUILT WTACHER =============== ++++ ${Random().nextInt(100)}");

//           return CupertinoScrollbar(
//             child: ListView.builder(
//               physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//               itemCount: notes.length,
//               itemBuilder: (context, index) {
//                 var note = notes[index];

//                 return Card(
//                   elevation: 5.w,
//                   margin: EdgeInsets.all(10.w),
//                   child: <Widget>[
//                     note.id.text.italic.make(),
//                     note.title.text.make(),
//                     note.text.text.make(),
//                     note.trash.toString().text.make(),
//                     note.znote.text.make(),
//                     note.created.text.make(),
//                     note.modified.text.make(),
//                     note.tags.toString().text.make(),
//                   ].vStack(),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(CupertinoIcons.pencil_outline, color: Colors.white),
//         backgroundColor: Colors.black,
//         onPressed: () {
//           for (int x = 0; x < 200; x++)
//             Get.find<NotesController>().addNewNote(LocalNotesModel(
//               title: '_titleController.text.encrypt',
//               text: '_textController.text.encrypt',
//               znote: 'jsonEncode(_quillController.toDelta().toJson()).encrypt',
//               trash: false,
//               created: '${DateTime.now().toString()}',
//               modified: '${DateTime.now()}',
//               tags: <String>['TAG_1', 'TAG_2', 'TAG_3'],
//             ));
//         },
//       ),
//     );
//   }
// }
