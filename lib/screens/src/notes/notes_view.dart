import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/cubit/note_search_cubit/note_search_cubit.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/services/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'widgets/notes_widgets.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key key}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> with TickerProviderStateMixin {
  TabController _tabController;

  int _animateIndex = 0;
  String sortNotes;
  List<NotesModel> _notes = List<NotesModel>();

  final MultiSelectController _multiSelectController = MultiSelectController();
  // final HiveDBServices _hiveDBServices = HiveDBServices();
  int noteIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // _speedDialController = SpeedDialController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NotesAppBar(_tabController),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (BuildContext context, HomeState homeState) {
          return ValueListenableBuilder(
            valueListenable: Hive.box<NotesModel>('givnotes').listenable(),
            builder: (BuildContext context, Box<NotesModel> box, Widget widget) {
              _notes = box.values.where((element) => element.trash == homeState.trash).toList();

              if (box.isEmpty || _notes.length == 0) {
                return NotesEmptyView(isTrash: homeState.trash);
              }

              return BlocBuilder<HydratedPrefsCubit, HydratedPrefsState>(
                builder: (context, prefState) {
                  return BlocProvider.of<HomeCubit>(context).state.global == true
                      ? Center(
                          child: Container(
                          child: Text(
                            "Global is coming later in future updates!\nStay tuned.",
                            textAlign: TextAlign.center,
                          ),
                        ))
                      : AnimationLimiter(
                          child: CupertinoScrollbar(
                            child: ListView.builder(
                              itemCount: _notes.length,
                              itemBuilder: (context, index) {
                                sortNotes = prefState.sortBy;

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

                                _animateIndex = index;
                                index = _notes.length - index - 1;

                                NotesModel note = _notes[index];

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

                                            if (!homeState.trash) {
                                              note.trash = !note.trash;
                                              note.save();

                                              Toast.show("moved to trash", context);

                                              _multiSelectController.set(_notes.length);
                                            } else {
                                              note.trash = false;
                                              note.save();

                                              Toast.show("moved to notes", context);

                                              _multiSelectController.set(_notes.length);
                                            }
                                          },
                                        ),
                                        secondaryActions: <Widget>[
                                          !homeState.trash
                                              ? iconSlideAction(Colors.red, Icons.delete, 'Trash')
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
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return state.trash == false
              ? FloatingActionButton(
                  heroTag: 'fab',
                  child: Icon(CupertinoIcons.add, color: Colors.white),
                  backgroundColor: Colors.black,
                  onPressed: () async {
                    if (_multiSelectController.isSelecting) {
                      //TODO flag
                      // _speedDialController.unfold();
                    } else {
                      await HandlePermission().requestPermission().then((value) async {
                        if (value) {
                          BlocProvider.of<NoteAndSearchCubit>(context).updateIsEditing(true);
                          BlocProvider.of<NoteAndSearchCubit>(context).updateNoteMode(NoteMode.Adding);
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
                        }
                      });
                    }
                  },
                )
              : SizedBox.shrink();
        },
      ),
    );
  }

  IconSlideAction iconSlideAction(Color color, IconData icon, String caption) {
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
}
