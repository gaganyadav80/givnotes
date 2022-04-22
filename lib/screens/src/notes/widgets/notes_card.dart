import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/packages/dynamic_text_highlighting.dart';
import 'package:intl/intl.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/src/notes/src/notes_model.dart';
import 'package:givnotes/services/services.dart';
// For localizations use [timeago] package
import 'package:givnotes/packages/timeago-3.1.0/timeago.dart' as timeago;

class NotesCard extends StatefulWidget {
  const NotesCard({
    Key? key,
    required this.note,
    required this.showTags,
    this.canMultiSelect = true,
    //TODO improve search text functionality
    this.searchText = '',
  }) : super(key: key);

  final NotesModel note;
  final bool showTags;
  final bool canMultiSelect;
  final String searchText;

  @override
  _NotesCardState createState() => _NotesCardState();
}

class _NotesCardState extends State<NotesCard> {
  final Map<String, int>? _allTagsMap = Database.tags;
  final RxString createdAgo = ''.obs;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    timeago.format(DateTime.parse(widget.note.created!), locale: 'en_short');
    timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      createdAgo.value = timeago.format(DateTime.parse(widget.note.created!),
          locale: 'en_short');
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HydratedPrefsCubit prefsCubit =
        BlocProvider.of<HydratedPrefsCubit>(context);

    return GetX<MultiSelectController>(
      builder: (MultiSelectController controller) {
        return Card(
          elevation: 0,
          shape: controller.isSelected(widget.note.id) && widget.canMultiSelect
              ? Border(
                  left: BorderSide(width: 3.w, color: const Color(0xFFDD4C4F)))
              : null,
          color: controller.selectedIndexes.contains(widget.note.id) &&
                  widget.canMultiSelect
              ? Colors.grey[300]
              : Colors.white,
          margin: EdgeInsets.zero,
          child: InkWell(
            borderRadius: BorderRadius.circular(0),
            onTap: () {
              if (controller.isSelecting && widget.canMultiSelect) {
                controller.select(widget.note.id);
              } else {
                BlocProvider.of<NoteStatusCubit>(context)
                    .updateNoteMode(NoteMode.editing);
                Navigator.pushNamed(context, RouterName.editorRoute,
                    arguments: [NoteMode.editing, widget.note]);
              }
            },
            onLongPress: !widget.canMultiSelect
                ? null
                : () => controller.select(widget.note.id),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                        createdAgo.value,
                        style: TextStyle(
                          fontSize: 12.w,
                          color: Colors.grey,
                        ),
                      ).paddingOnly(top: 36.w)),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 10.w),
                        widget.note.tags.isEmpty || !widget.showTags
                            ? SizedBox(height: 5.w)
                            : Container(
                                height:
                                    prefsCubit.state.compactTags! ? 8.h : 18.h,
                                color: Colors.transparent,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.note.tags.length,
                                  itemBuilder: (context, index) {
                                    String tagsTitle = widget.note.tags[index];
                                    Color color =
                                        Color(_allTagsMap![tagsTitle]!);

                                    return prefsCubit.state.compactTags!
                                        ? Container(
                                            width: 30.w,
                                            margin: EdgeInsets.only(right: 5.w),
                                            decoration: BoxDecoration(
                                              color: color,
                                              borderRadius:
                                                  BorderRadius.circular(3.r),
                                            ),
                                            child: const SizedBox.shrink(),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(right: 5.w),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w),
                                            decoration: BoxDecoration(
                                              color: color,
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                            ),
                                            child: Center(
                                              child: Text(
                                                tagsTitle,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.5.w,
                                                  fontSize: 9.w,
                                                ),
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ),
                        SizedBox(height: 5.w),
                        DynamicTextHighlighting(
                          caseSensitive: false,
                          highlights: [
                            widget.searchText.isEmpty
                                ? 'null'
                                : widget.searchText
                          ],
                          text: widget.note.title!,
                          style: TextStyle(
                            fontSize: 18.w,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // SizedBox(height: 5.w),
                        DynamicTextHighlighting(
                          caseSensitive: false,
                          highlights: [
                            widget.searchText.isEmpty
                                ? 'null'
                                : widget.searchText
                          ],
                          text: widget.note.text!,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 5.0.w),
                        prefsCubit.state.compactTags!
                            ? const SizedBox.shrink()
                            : Text(
                                "created  ${DateFormat.yMMMd().add_jm().format(DateTime.parse(widget.note.created!))}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.w,
                                  color: Colors.grey,
                                  // fontStyle: FontStyle.italic,
                                ),
                              ),
                        SizedBox(height: 10.0.w),
                        const Divider(height: 0.0, thickness: 1.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
