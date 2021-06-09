import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/src/notes/src/notes_model.dart';
import 'package:givnotes/services/services.dart';
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
  final MultiSelectController multiSelectController = Get.find<MultiSelectController>();

  @override
  void initState() {
    super.initState();
    _created = DateFormat.yMMMd().add_jm().format(DateTime.parse(widget.note.created));
    _allTagsMap = VariableService().prefsBox.allTagsMap;
  }

  @override
  Widget build(BuildContext context) {
    final HydratedPrefsCubit prefsCubit = BlocProvider.of<HydratedPrefsCubit>(context);

    return Obx(
      () => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        color: multiSelectController.selectedIndexes.contains(widget.note.id) ? Colors.grey[300] : Colors.white,
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(0),
          onTap: () {
            if (multiSelectController.isSelecting) {
              multiSelectController.select(widget.note.id);
            } else {
              BlocProvider.of<NoteStatusCubit>(context).updateNoteMode(NoteMode.Editing);
              Navigator.pushNamed(context, RouterName.editorRoute, arguments: [NoteMode.Editing, widget.note]);
            }
          },
          onLongPress: () {
            multiSelectController.select(widget.note.id);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5.0.w),
                widget.note.tags.length == 0
                    ? SizedBox(height: 5.w)
                    : Container(
                        margin: EdgeInsets.only(top: 6.w),
                        height: prefsCubit.state.compactTags ? 8.h : 18.h,
                        color: Colors.transparent,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.note.tags.length,
                          itemBuilder: (context, index) {
                            String tagsTitle = widget.note.tags[index];
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
                                    height: 18.h,
                                    padding: EdgeInsets.symmetric(horizontal: 5.w),
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
                  style: TextStyle(color: Colors.grey[800]),
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
