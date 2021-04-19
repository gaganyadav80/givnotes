import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/utils.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/packages/multi_select_notes.dart';
import 'package:givnotes/routes.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/global/size_utils.dart';
import 'package:givnotes/global/variables.dart';

class NotesCard extends StatefulWidget {
  NotesCard({
    Key key,
    @required this.index,
    @required this.note,
    this.notesViewUpdate,
    this.isLast = false,
  }) : super(key: key);

  final int index;
  final NotesModel note;
  final Function notesViewUpdate;
  final bool isLast;

  @override
  _NotesCardState createState() => _NotesCardState();
}

class _NotesCardState extends State<NotesCard> {
  String _created;
  Map<String, int> _allTagsMap;

  @override
  void initState() {
    super.initState();
    _created = DateFormat.yMMMd().add_jm().format(widget.note.created);
    _allTagsMap = prefsBox.allTagsMap;
  }

  @override
  Widget build(BuildContext context) {
    // final NoteEditStore _noteEditStore = context.read(noteEditProvider);
    // _splashColor = widget.note.tagsMap.length == 0 ? Colors.black : Color(widget.note.tagsMap.values.last);
    final hm = screenHeight / 100;
    final wm = screenWidth / 100;
    final HydratedPrefsCubit prefsCubit = BlocProvider.of<HydratedPrefsCubit>(context);
    final notesState = Get.put(SelectMultiNotes());
    return Obx(
      () => Container(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          color: notesState.selectedIndexes.contains(widget.index) ? Colors.grey[300] : Colors.white,
          margin: EdgeInsets.zero,
          child: InkWell(
            borderRadius: BorderRadius.circular(0),
            onTap: () {
              if (notesState.selectedIndexes.length != 0) {
                notesState.selected(n: widget.index);
              } else {
                BlocProvider.of<NoteAndSearchCubit>(context).updateNoteMode(NoteMode.Editing);
                Navigator.pushNamed(context, RouterName.editorRoute, arguments: [NoteMode.Editing, widget.note]);
              }
            },
            onLongPress: () {
              notesState.selected(n: widget.index);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5.0),
                  widget.note.tagsMap.length == 0
                      ? SizedBox(height: wm)
                      : Container(
                          margin: EdgeInsets.only(top: 1.5 * wm),
                          height: prefsCubit.state.compactTags ? 1 * hm : 2.3 * hm,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.transparent,
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.note.tagsMap.length,
                            itemBuilder: (context, index) {
                              String tagsTitle = widget.note.tagsMap.keys.toList()[index];
                              Color color = Color(_allTagsMap[tagsTitle]);

                              return prefsCubit.state.compactTags
                                  ? Container(
                                      width: 7.6 * wm,
                                      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: SizedBox.shrink(),
                                    )
                                  : Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          tagsTitle,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                            fontSize: 8,
                                          ),
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                  SizedBox(height: screenWidth / 100),
                  Text(
                    widget.note.title,
                    style: TextStyle(
                      fontSize: 4.4 * wm,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: screenWidth / 100),
                  Text(
                    widget.note.text,
                    style: TextStyle(
                      color: Colors.grey[800],
                      // fontSize: 3 * wm,
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "created  $_created",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 3 * wm,
                      color: Colors.grey,
                      // fontStyle: FontStyle.italic,
                    ),
                  ),
              SizedBox(height: 10.0),
              Divider(height: 0.0, thickness: 1.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
