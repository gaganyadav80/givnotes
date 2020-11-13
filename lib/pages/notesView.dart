import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:givnotes/database/HiveDB.dart';
import 'package:givnotes/packages/unicorndial/speed_dial_controller.dart';
import 'package:givnotes/packages/unicorndial/unicorndial.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/variables/prefs.dart';
import 'package:givnotes/packages/multi_select_item.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/ui/const_notes_view.dart';
import 'package:givnotes/utils/permissions.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

IconData fabIcon = Icons.add;
String fabLabel = '';

class NotesView extends StatefulWidget {
  final bool isTrash;
  NotesView({key, this.isTrash}) : super(key: key);

  @override
  NotesViewState createState() => NotesViewState();
}

class NotesViewState extends State<NotesView> {
  int _animateIndex = 0;
  List<NotesModel> _notes = List<NotesModel>();
  MultiSelectController _multiSelectController;
  SpeedDialController _speedDialController;

  @override
  void initState() {
    _multiSelectController = MultiSelectController();
    _speedDialController = SpeedDialController();
    super.initState();
  }

  refreshNotesView() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ValueListenableBuilder(
        valueListenable: Hive.box<NotesModel>('givnnotes').listenable(),
        builder: (context, Box<NotesModel> box, widget) {
          _notes = box.values.where((element) => element.trash == Var.isTrash).toList();

          if (box.isEmpty || _notes.length == 0) {
            return NotesEmptyView();
          }

          return AnimationLimiter(
            child: ListView.builder(
              itemCount: _notes.length,
              //TODO maybe remove divider in const_notes_view and use separator
              // separatorBuilder: (context, index) => Divider(
              //   height: 0.057 * wm,
              //   color: Colors.black,
              //   indent: 10,
              //   endIndent: 10,
              // ),
              itemBuilder: (context, index) {
                _animateIndex = index;
                index = _notes.length - index - 1;

                var note = _notes[index];

                return AnimationConfiguration.staggeredList(
                  position: _animateIndex,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 25.0,
                    child: FadeInAnimation(
                      child: Slidable(
                        key: UniqueKey(),
                        actionPane: SlidableBehindActionPane(),
                        actionExtentRatio: 1.0,
                        dismissal: SlidableDismissal(
                          child: SlidableDrawerDismissal(),
                          onDismissed: (actionType) {
                            if (!Var.isTrash) {
                              note.trash = !note.trash;
                              note.save();
                              print('moved to Trash');
                              // Scaffold.of(context).showSnackBar(SnackBar(content: Text('moved to Trash')));

                              _multiSelectController.set(_notes.length);
                            } else {
                              note.trash = false;
                              note.save();
                              print('moved to Notes');
                              // Scaffold.of(context).showSnackBar(SnackBar(content: Text('moved to Notes')));

                              _multiSelectController.set(_notes.length);
                            }
                          },
                        ),
                        secondaryActions: <Widget>[
                          !Var.isTrash
                              ? iconSlideAction(
                                  Colors.red,
                                  Icons.delete,
                                  'Trash',
                                )
                              : iconSlideAction(
                                  Color(0xff66a9e0),
                                  Icons.restore,
                                  'Resotre',
                                ),
                        ],
                        child: NotesCard(
                          note: note,
                          index: index,
                          multiSelectController: _multiSelectController,
                          notesViewUpdate: refreshNotesView,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: !_multiSelectController.isSelecting && !Var.isTrash
          ? UnicornDialer(
              parentHeroTag: 'parent',
              parentButton: Icon(
                CupertinoIcons.add,
                color: Colors.white,
              ),
              parentButtonBackground: Colors.black,
              finalButtonIcon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              hasBackground: true,
              controller: _speedDialController,
              childButtons: unicornButton,
              onMainButtonPressed: () async {
                await HandlePermission().requestPermission().then((value) {
                  if (value) {
                    Var.isEditing = true;
                    Var.noteMode = NoteMode.Adding;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ZefyrEdit(noteMode: NoteMode.Adding),
                      ),
                    );
                  } else {
                    if (isPermanentDisabled) {
                      HandlePermission().permanentDisabled(context);
                    }
                    setState(() => Var.selectedIndex = 0);
                  }
                });
              },
            )
          : !_multiSelectController.isSelecting && Var.isTrash
              ? SizedBox.shrink()
              : FloatingActionButton(
                  heroTag: 'parent',
                  backgroundColor: Colors.black,
                  splashColor: Colors.black,
                  elevation: 5,
                  child: Icon(
                    fabIcon,
                    color: Colors.white,
                  ),
                  // label: Text(
                  //   fabLabel,
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //   ),
                  // ),
                  onPressed: () {},
                ),
    );
  }

  Widget iconSlideAction(Color color, IconData icon, String caption) {
    return IconSlideAction(
      // caption: 'Trash',
      color: color,
      // icon: Icons.delete,
      iconWidget: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                Text(
                  caption,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
      onTap: () => Scaffold.of(context).showSnackBar(SnackBar(content: Text('moved to Trash'))),
    );
  }

  List<UnicornButton> unicornButton = [
    Var.isTrash
        ? UnicornButton(
            currentButton: FloatingActionButton(
              backgroundColor: Colors.black,
              splashColor: Colors.black,
              elevation: 5,
              child: Icon(
                Icons.restore,
                color: Colors.white,
              ),
              onPressed: () async {},
            ),
          )
        : UnicornButton(
            currentButton: FloatingActionButton(
              backgroundColor: Colors.black,
              splashColor: Colors.black,
              elevation: 5,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () async {},
            ),
          ),
  ];

  Widget floatingActionButton() {
    return !_multiSelectController.isSelecting && !Var.isTrash
        ? FloatingActionButton(
            heroTag: 'b',
            tooltip: 'New Note',
            backgroundColor: Colors.black,
            splashColor: Colors.black,
            elevation: 5,
            child: Icon(Icons.add),
            onPressed: () async {
              await HandlePermission().requestPermission().then((value) {
                if (value) {
                  Var.isEditing = true;
                  Var.noteMode = NoteMode.Adding;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ZefyrEdit(noteMode: NoteMode.Adding),
                    ),
                  );
                } else {
                  if (isPermanentDisabled) {
                    HandlePermission().permanentDisabled(context);
                  }
                  setState(() => Var.selectedIndex = 0);
                }
              });

              // if (animatedListKey.currentState != null) animatedListKey.currentState.insertItem(_notes.length);
              // count++;
            },
          )
        : !_multiSelectController.isSelecting && Var.isTrash
            ? SizedBox.shrink()
            : Container(
                height: 14 * wm,
                child: FloatingActionButton.extended(
                  heroTag: 'b',
                  backgroundColor: Colors.black,
                  splashColor: Colors.black,
                  elevation: 5,
                  icon: Icon(fabIcon),
                  label: Text(fabLabel),
                  onPressed: getMultiselectFunction,
                ),
              );
  }

  Function() getMultiselectFunction() {
    if (!Var.isTrash) {
      return () => print('call trash');
    } else if (Var.isTrash) {
      return () => print('call restore');
    }
    return () {};
  }

  void delete() {
    _multiSelectController.selectedIndexes.forEach((element) {
      print('delete note');
    });

    // setState(() {
    _multiSelectController.set(_notes.length);
    fabIcon = Icons.add;
    // });
  }

  void trash() {
    _multiSelectController.selectedIndexes.forEach((element) {
      print('trash note');
    });

    // setState(() {
    _multiSelectController.set(_notes.length);
    fabIcon = Icons.add;
    // });
  }

  void restore() {
    _multiSelectController.selectedIndexes.forEach((element) {
      print('restore note');
    });

    // setState(() {
    _multiSelectController.set(_notes.length);
    fabIcon = Icons.add;
    // });
  }
}

// Dismissible(
//   key: UniqueKey(),
//   background: Container(
//     color: Var.isTrash ? Colors.teal[300] : Color(0xffEC625C),
//     width: double.infinity,
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Icon(
//           Var.isTrash ? Icons.restore : Icons.delete,
//           size: 10 * wm,
//         ),
//         SizedBox(width: 10 * wm)
//       ],
//     ),
//   ),
//   direction: DismissDirection.endToStart,
//   onDismissed: (direction) {
//     if (!Var.isTrash) {
//       note.trash = !note.trash;
//       note.save();

//       _multiSelectController.set(_notes.length);
//     } else {
//       note.trash = false;
//       note.save();
//       print('moved to notes');

//       _multiSelectController.set(_notes.length);
//     }
//   },
//   child: NotesCard(
//     note: note,
//     index: index,
//     multiSelectController: _multiSelectController,
//     notesViewUpdate: refreshNotesView,
//   ),
// ),

// return multiSelectController.isSelecting == false
//     ? OpenContainer(
//         transitionDuration: Duration(milliseconds: 500),
//         transitionType: ContainerTransitionType.fade,
//         closedElevation: 0.0,
//         openElevation: 0.0,
//         closedBuilder: (context, action) {
//           return NotesCard(
//             controller: multiSelectController,
//             notes: notes,
//             index: widget.index,
//           );
//         },
//         openBuilder: (context, action) {
//           Var.noteMode = NoteMode.Editing;
//           Var.note = notes[widget.index];

//           return ZefyrEdit(noteMode: NoteMode.Editing);
//         },
//       )
