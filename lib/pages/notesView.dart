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
import 'package:preferences/preferences.dart';

// IconData fabIcon = Icons.add;
// String fabLabel = '';

// final GlobalKey<ScaffoldState> notesScaffoldKey = GlobalKey<ScaffoldState>();

class NotesView extends StatefulWidget {
  final bool isTrash;
  NotesView({key, this.isTrash}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

//TODO poorly implemented, fix it
_NotesViewState notesViewState;

class _NotesViewState extends State<NotesView> {
  int _animateIndex = 0;
  List<NotesModel> _notes = List<NotesModel>();
  MultiSelectController _multiSelectController;
  SpeedDialController _speedDialController;

  @override
  void initState() {
    compactTags = prefsBox.get('compactTags', defaultValue: false);
    sortNotes = prefsBox.get('sortNotes', defaultValue: 'created');

    notesViewState = this;

    _multiSelectController = MultiSelectController();
    _speedDialController = SpeedDialController();
    super.initState();
  }

  refreshNotesView() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    compactTags = prefsBox.get('compactTags', defaultValue: false);
    sortNotes = prefsBox.get('sortNotes', defaultValue: 'created');

    return WillPopScope(
      onWillPop: _onPop,
      child: Scaffold(
        // key: notesScaffoldKey,
        backgroundColor: Colors.white,
        body: ValueListenableBuilder(
          valueListenable: Hive.box<NotesModel>('givnotes').listenable(),
          builder: (context, Box<NotesModel> box, widget) {
            _notes = box.values.where((element) => element.trash == Var.isTrash).toList();

            if (sortNotes == 'created')
              _notes.sort((a, b) => a.created.compareTo(b.created));
            else if (sortNotes == 'modified')
              _notes.sort((a, b) => a.modified.compareTo(b.modified));
            else if (sortNotes == 'a-z')
              _notes.sort((a, b) => b.title.compareTo(a.title));
            else if (sortNotes == 'z-a') {
              _notes.sort((a, b) => a.title.compareTo(b.title));
            } else
              _notes.sort((a, b) => a.created.compareTo(b.created));

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
                              _multiSelectController.deselectAll();

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
        floatingActionButton: !Var.isTrash
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
                // childButtons: Var.isTrash ? trashUnicornButton : unicornButton,
                childButtons: Var.isTrash
                    ? [
                        UnicornButton(
                          currentButton: FloatingActionButton(
                            backgroundColor: Colors.black,
                            splashColor: Colors.black,
                            elevation: 5,
                            child: Icon(
                              Icons.restore,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              // print('moved to Notes');
                              restore();
                            },
                          ),
                        ),
                      ]
                    : [
                        UnicornButton(
                          currentButton: FloatingActionButton(
                            backgroundColor: Colors.black,
                            splashColor: Colors.black,
                            elevation: 5,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              // print('moved to Trash');
                              trash();
                            },
                          ),
                        ),
                      ],
                onMainButtonPressed: () async {
                  if (_multiSelectController.isSelecting) {
                    _speedDialController.unfold();
                  } else {
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
                  }
                },
              )
            : Hero(
                tag: 'parent',
                child: SizedBox.shrink(),
              ),
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
      onTap: () => print('moved to Trash'),
    );
  }

  void delete() {
    _multiSelectController.selectedIndexes.forEach((element) {
      print('delete note');
    });

    // setState(() {
    _multiSelectController.set(_notes.length);
    // fabIcon = Icons.add;
    // });
  }

  void trash() {
    _multiSelectController.selectedIndexes.forEach((element) {
      print('trash note');
    });

    setState(() {
      _multiSelectController.set(_notes.length);
      // fabIcon = Icons.add;
    });
  }

  void restore() {
    _multiSelectController.selectedIndexes.forEach((element) {
      print('restore note');
    });

    setState(() {
      _multiSelectController.set(_notes.length);
      // fabIcon = Icons.add;
    });
  }

  Future<bool> _onPop() async {
    // print(_multiSelectController.isSelecting);
    if (_multiSelectController.isSelecting) {
      setState(() {
        _multiSelectController.deselectAll();
      });

      return false;
    }
    return true;
  }
}

class NotesModelSheet extends StatefulWidget {
  NotesModelSheet({Key key}) : super(key: key);

  @override
  _NotesModelSheetState createState() => _NotesModelSheetState();
}

class _NotesModelSheetState extends State<NotesModelSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70 * wm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
            child: Text(
              'Notes Options',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(height: 20),
          DropdownPreference(
            'Sort notes',
            'sort_notes',
            defaultVal: 'Date created',
            values: ['Date created', 'Date modified', 'A-Z Title', 'Z-A Title'],
            onChange: ((String value) {
              print(value);
              if (value == 'Date created')
                prefsBox.put('sortNotes', 'created');
              else if (value == 'Date modified')
                prefsBox.put('sortNotes', 'modified');
              else if (value == 'A-Z Title')
                prefsBox.put('sortNotes', 'a-z');
              else
                prefsBox.put('sortNotes', 'z-a');

              notesViewState.setState(() {});
            }),
          ),
          SwitchPreference(
            'Compact Tags',
            'biometric',
            desc: 'Enable compact tags in notes view',
            defaultVal: false,
            onEnable: () {
              prefsBox.put('compactTags', true);
              notesViewState.setState(() {});
            },
            onDisable: () {
              prefsBox.put('compactTags', false);
              notesViewState.setState(() {});
            },
          ),
        ],
      ),
    );
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
