import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/services/src/multi_select_notes.dart';

class NotesCard extends StatefulWidget {
  NotesCard({
    Key key,
    @required this.index,
    @required this.note,
  }) : super(key: key);

  final int index;
  final NotesModel note;

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
    final HydratedPrefsCubit prefsCubit = BlocProvider.of<HydratedPrefsCubit>(context);
    final notesState = Get.put(SelectMultiNotes());
    return Obx(
      () => Card(
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
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5.0.w),
                widget.note.tagsMap.length == 0
                    ? SizedBox(height: 5.w)
                    : Container(
                        margin: EdgeInsets.only(top: 6.w),
                        height: prefsCubit.state.compactTags ? 8.h : 16.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
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
                                    width: 30.w,
                                    margin: EdgeInsets.only(right: 5.w),
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    child: SizedBox.shrink(),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(right: 5.w),
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        tagsTitle,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5.w,
                                          fontSize: 8.w,
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ),
                SizedBox(height: 5.w),
                Text(
                  widget.note.title,
                  style: TextStyle(
                    fontSize: 17.w,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.w),
                Text(
                  widget.note.text,
                  style: TextStyle(
                    color: Colors.grey[800],
                    // fontSize: 3 * wm,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.0.w),
                Text(
                  "created  $_created",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12.w,
                    color: Colors.grey,
                    // fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 10.0.w),
                Divider(height: 0.0, thickness: 1.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
