import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/packages/packages.dart';

import 'widgets/notes_widgets.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key key}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> with TickerProviderStateMixin {
  int sortNotes;
  List<NotesModel> _notes = <NotesModel>[];

  int noteIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (BlocProvider.of<HomeCubit>(context).state.trash) {
          BlocProvider.of<HomeCubit>(context).updateTrash(false);
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: NotesAppBar(),
        body: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) => previous != current,
          builder: (BuildContext context, HomeState homeState) {
            return ValueListenableBuilder(
              valueListenable: Hive.box<NotesModel>('givnotes').listenable(),
              builder: (BuildContext context, Box<NotesModel> box, Widget widget) {
                _notes = box.values.where((element) => element.trash == homeState.trash).toList();

                if ((box.isEmpty || _notes.length == 0)) {
                  return NotesEmptyView(isTrash: homeState.trash);
                }

                return BlocBuilder<HydratedPrefsCubit, HydratedPrefsState>(
                  builder: (context, prefState) {
                    return CupertinoScrollbar(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        // separatorBuilder: (context, index) => Divider(thickness: 1.0, height: 0.0),
                        itemCount: _notes.length,
                        itemBuilder: (context, index) {
                          sortNotes = prefState.sortBy;

                          if (sortNotes == 0)
                            _notes.sort((a, b) => a.created.compareTo(b.created));
                          else if (sortNotes == 1)
                            _notes.sort((a, b) => a.modified.compareTo(b.modified));
                          else if (sortNotes == 2)
                            _notes.sort((a, b) => b.title.compareTo(a.title));
                          else if (sortNotes == 3) {
                            _notes.sort((a, b) => a.title.compareTo(b.title));
                          } else
                            _notes.sort((a, b) => a.created.compareTo(b.created));

                          index = _notes.length - index - 1;

                          NotesModel note = _notes[index];

                          return Slidable(
                            key: UniqueKey(),
                            actionPane: SlidableBehindActionPane(),
                            actionExtentRatio: 1.0,
                            dismissal: SlidableDismissal(
                              child: SlidableDrawerDismissal(),
                              onDismissed: (actionType) {
                                // _multiSelectController.deselectAll();

                                if (!homeState.trash) {
                                  note.trash = !note.trash;
                                  note.save();

                                  Toast.show("moved to trash", context);

                                  // _multiSelectController.set(_notes.length);
                                } else {
                                  note.trash = false;
                                  note.save();

                                  Toast.show("moved to notes", context);

                                  // _multiSelectController.set(_notes.length);
                                }
                              },
                            ),
                            secondaryActions: <Widget>[
                              !homeState.trash
                                  ? iconSlideAction(Color(0xFFDD4C4F), CupertinoIcons.trash, 'TRASH')
                                  : iconSlideAction(
                                      Color(0xFF82C8F6),
                                      CupertinoIcons.arrow_up_bin,
                                      'RESTORE',
                                    ),
                            ],
                            child: NotesCard(
                              note: note,
                              index: index,
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
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
                Icon(
                  icon,
                  color: Colors.white.withOpacity(0.9),
                ),
                SizedBox(height: 15.0.w),
                Text(
                  caption,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
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
