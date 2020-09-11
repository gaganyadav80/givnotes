import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/enums/prefs.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/ui/const_notes_view.dart';
import 'package:givnotes/utils/multi_select_item.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:givnotes/utils/permissions.dart';
import 'package:morpheus/morpheus.dart';

MultiSelectController multiSelectController = MultiSelectController();
List notes = List();
IconData fabIcon = Icons.add;
String fabLabel = '';

class NotesView extends StatefulWidget {
  final bool isTrash;
  NotesView({this.isTrash});

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  int animateIndex = 0;

  void refreshNotesView() {
    setState(() {});
  }

  @override
  void initState() {
    // multiSelectController.disableEditingWhenNoneSelected = true;
    // if (prefsBox.containsKey('searchList')) {
    //   multiSelectController.set((prefsBox.get('searchList') as List).length);
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        // future: widget.isTrash == false ? NotesDB.getNoteList() : NotesDB.getTrashNoteList(),
        future: NotesDB.getNoteList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            notes = snapshot.data;
            if (notes.length == 0) {
              //
              return const NotesEmptyView();
              //
            } else {
              return AnimationLimiter(
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    animateIndex = index;
                    index = notes.length - index - 1;
                    //
                    // created = DateFormat('dd-MM-yyyy').parse(notes[index]['created']);
                    // modified = DateFormat('dd-MM-yyyy').parse(notes[index]['modified']);
                    //
                    return AnimationConfiguration.staggeredList(
                      position: animateIndex,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 25.0,
                        child: FadeInAnimation(
                          child: Dismissible(
                            key: UniqueKey(),
                            background: Container(
                              color: Var.isTrash ? Colors.teal[300] : Colors.red[400],
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Var.isTrash ? Icons.restore : Icons.restore_from_trash,
                                    size: 10 * wm,
                                  ),
                                  SizedBox(width: 10 * wm)
                                ],
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              if (!Var.isTrash) {
                                NotesDB.updateNote({
                                  'id': notes[index]['id'],
                                  'trash': 1,
                                });
                                print('moved to trash');

                                // setState(() {
                                multiSelectController.set(notes.length);
                                // });
                              } else {
                                NotesDB.updateNote({
                                  'id': notes[index]['id'],
                                  'trash': 0,
                                });
                                print('moved to notes');

                                multiSelectController.set(notes.length);
                              }
                              setState(() {});
                            },
                            child: OnlyUpdateNoteCard(
                              index: index,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
          return Scaffold(backgroundColor: Colors.white);
        },
      ),
      floatingActionButton: OnlyUpdateFAB(
        refreshNotesView: refreshNotesView,
      ),
    );
  }
}

// ignore: must_be_immutable
class OnlyUpdateNoteCard extends StatefulWidget {
  OnlyUpdateNoteCard({
    Key key,
    @required this.index,
  }) : super(key: key);

  final int index;

  @override
  _OnlyUpdateNoteCardState createState() => _OnlyUpdateNoteCardState();
}

class _OnlyUpdateNoteCardState extends State<OnlyUpdateNoteCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        setState(() {
          multiSelectController.toggle(widget.index);
          fabIcon = Var.isTrash ? Icons.restore : Icons.restore_from_trash;
          fabLabel = Var.isTrash ? 'Restore' : 'Trash';
        });

        fabState.refreshFab();
      },
      onTap: () {
        if (multiSelectController.isSelecting) {
          setState(() {
            multiSelectController.toggle(widget.index);
            if (!multiSelectController.isSelecting) {
              fabIcon = Icons.add;
            }
          });

          fabState.refreshFab();
          //
        } else {
          Var.noteMode = NoteMode.Editing;
          Var.note = notes[widget.index];

          Navigator.push(
            context,
            MorpheusPageRoute(
              builder: (context) => ZefyrEdit(noteMode: NoteMode.Editing),
            ),
          );
        }
      },
      child: NotesCard(
        controller: multiSelectController,
        notes: notes,
        index: widget.index,
      ),
    );
  }
}

class OnlyUpdateFAB extends StatefulWidget {
  OnlyUpdateFAB({Key key, this.refreshNotesView}) : super(key: key);

  final Function() refreshNotesView;

  @override
  _OnlyUpdateFABState createState() => _OnlyUpdateFABState();
}

_OnlyUpdateFABState fabState = _OnlyUpdateFABState();

class _OnlyUpdateFABState extends State<OnlyUpdateFAB> {
  void refreshFab() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fabState = this;
  }

  @override
  Widget build(BuildContext context) {
    return !multiSelectController.isSelecting && !Var.isTrash
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
            },
          )
        : !multiSelectController.isSelecting && Var.isTrash
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
                  onPressed: getMultiselectFunction(),
                ),
              );
  }

  Function() getMultiselectFunction() {
    if (!Var.isTrash) {
      return () => trash();
    } else if (Var.isTrash) {
      return () => restore();
    }
    return () {};
  }

  void delete() {
    multiSelectController.selectedIndexes.forEach((element) {
      NotesDB.deleteNote(element);
    });

    // setState(() {
    multiSelectController.set(notes.length);
    fabIcon = Icons.add;
    // });
    widget.refreshNotesView();
  }

  void trash() {
    multiSelectController.selectedIndexes.forEach((element) {
      NotesDB.updateNote({
        'id': notes[element]['id'],
        'trash': 1,
      });
    });

    // setState(() {
    multiSelectController.set(notes.length);
    fabIcon = Icons.add;
    // });
    widget.refreshNotesView();
  }

  void restore() {
    multiSelectController.selectedIndexes.forEach((element) {
      NotesDB.updateNote({
        'id': notes[element]['id'],
        'trash': 0,
      });
    });

    // setState(() {
    multiSelectController.set(notes.length);
    fabIcon = Icons.add;
    // });
    widget.refreshNotesView();
  }
}

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
