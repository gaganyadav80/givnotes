import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/cubit/cubits.dart';
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
  final RxBool _showSearch = false.obs;
  final FocusNode _focusNode = FocusNode();
  final RxList<NotesModel> _searchList = <NotesModel>[].obs;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      final text = _textController.text;

      if (text.trim().isNotEmpty) {
        _searchList.value = Get.find<NotesController>().notes.where((element) {
          return (element.title + ' ' + element.text + element.tags.join(' '))
                  .toLowerCase()
                  .contains(text.toLowerCase()) &&
              element.trash == false;
        }).toList();

        // _searchList
        //   ..clear()
        //   ..addAll(filterList);
        // Get.find<NotesController>().update();
        //
      } else if (text.isEmpty) {
        _searchList
          ..clear()
          ..addAll(Get.find<NotesController>()
              .notes
              .where((element) => element.trash == false)
              .toList());
        // Get.find<NotesController>().update();
      }
    });
  }

  @override
  void dispose() {
    _textController?.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56.h),
            child: Obx(() => _showSearch.value
                ? ShowUpAnimation(
                    animationDuration: const Duration(milliseconds: 200),
                    direction: Direction.vertical,
                    offset: -0.2,
                    child: AppBar(
                      backgroundColor: Colors.white,
                      elevation: 0.0,
                      automaticallyImplyLeading: false,
                      title: CupertinoSearchTextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        prefixInsets:
                            const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 4),
                        placeholder: 'Search notes',
                      ),
                      actions: [
                        CupertinoButton(
                          padding: EdgeInsets.only(right: 15.w),
                          child: 'Cancel'
                              .text
                              .semiBold
                              .color(CupertinoColors.systemGrey)
                              .make(),
                          onPressed: () {
                            _showSearch.value = false;
                            _textController.clear();
                            _focusNode.unfocus();
                          },
                        )
                      ],
                    ),
                  )
                : AppBar(
                    elevation: 0.0,
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    title: 'Notes'
                        .text
                        .heightRelaxed
                        .size(36.w)
                        .semiBold
                        .color(const Color(0xff32343D))
                        .make(),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: IconButton(
                          splashRadius: 25.0,
                          iconSize: 22.0.w,
                          icon: const Icon(CupertinoIcons.collections,
                              color: Colors.black),
                          onPressed: () => showCupertinoModalBottomSheet(
                            expand: true,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const NotesOptionModalSheet(),
                          ),
                        ),
                      ),
                      InkWell(
                        child: Icon(CupertinoIcons.search,
                            size: 28.w, color: Colors.black),
                        // splashRadius: 25.0,
                        key: widget.key,
                        onTap: () {
                          _showSearch.value = true;
                          _focusNode.requestFocus();
                        },
                      ),
                      SizedBox(width: 20.w),
                    ],
                  )),
          ),
          backgroundColor: Colors.white,
          body: GetBuilder<NotesController>(
            init: NotesController(),
            builder: (NotesController controller) {
              _searchList.value = controller.notes
                  .where((element) => element.trash == false)
                  .toList();
              print(controller.directory);

              if ((controller.notes.isEmpty)) {
                return const NotesEmptyView(isTrash: false);
              } else if (_searchList.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: 'Ops! nothing found'
                      .text
                      .center
                      .italic
                      .light
                      .lg
                      .gray400
                      .make(),
                );
              }

              return Obx(() => CupertinoScrollbar(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: _searchList.length,
                      itemBuilder: (context, index) {
                        final NotesModel note = _searchList[index];

                        return Slidable(
                          key: UniqueKey(),
                          endActionPane: ActionPane(
                            extentRatio: 0.25, // 0.25 or 0.20 * total items
                            motion: const DrawerMotion(),
                            // dismissible: ,
                            children: <Widget>[
                              iconSlideAction(const Color(0xFFDD4C4F),
                                  CupertinoIcons.trash, 'TRASH', () {
                                controller
                                    .updateNote(note.copyWith(trash: true));
                                Fluttertoast.showToast(msg: "moved to trash");
                              }),
                            ],
                          ),
                          child: NotesCard(
                              note: note,
                              showTags: true,
                              searchText: _textController.text),
                        );
                      },
                    ),
                  ));
            },
          ),
          floatingActionButton: Container(
            height: 65.w,
            width: 65.w,
            decoration: const BoxDecoration(
                color: Color(0xFFDD4C4F), shape: BoxShape.circle),
            child: FloatingActionButton(
              child: const Icon(CupertinoIcons.pencil_outline,
                  color: Colors.white),
              backgroundColor: const Color(0xFFDD4C4F),
              onPressed: () async {
                await HandlePermission.requestPermission().then((value) async {
                  if (value) {
                    BlocProvider.of<NoteStatusCubit>(context)
                        .updateIsEditing(true);
                    BlocProvider.of<NoteStatusCubit>(context)
                        .updateNoteMode(NoteMode.adding);
                    Navigator.pushNamed(
                      context,
                      RouterName.editorRoute,
                      arguments: [NoteMode.adding, null],
                    );
                  } else {
                    if (VariableService().isPermanentDisabled) {
                      HandlePermission.permanentDisabled(context);
                    }
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  CustomSlidableAction iconSlideAction(
      Color color, IconData icon, String caption, VoidCallback onTap) {
    return CustomSlidableAction(
      backgroundColor: color,
      child: <Widget>[
        Icon(icon),
        SizedBox(height: 8.w),
        caption.text.light.make(),
      ].vStack(axisSize: MainAxisSize.min),
      onPressed: (_) => onTap(),
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
