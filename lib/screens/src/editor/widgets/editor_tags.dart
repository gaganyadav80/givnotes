import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:get/get.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/database/database.dart';

import 'add_tags_page.dart';

class EditorTags extends StatefulWidget {
  const EditorTags({Key? key, required this.noteTagsList}) : super(key: key);

  final RxList<String> noteTagsList;

  @override
  _EditorTagsState createState() => _EditorTagsState();
}

class _EditorTagsState extends State<EditorTags> {
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  final TextEditingController _tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final NoteStatusCubit _noteEditStore =
        BlocProvider.of<NoteStatusCubit>(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(
          () => Row(
            children: [
              _buildNoteTags(_noteEditStore),
              widget.noteTagsList.isEmpty
                  ? const SizedBox.shrink()
                  : SizedBox(width: 10.w),
              BlocBuilder<NoteStatusCubit, NoteStatusState>(
                builder: (context, state) {
                  return state.isEditing
                      ? Container(
                          height: 32.w,
                          width: 32.w,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blueGrey,
                              width: 2.w,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25.r),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => AddTagScreen(
                                    controller: _tagController,
                                    isEditing: false,
                                    editTagTitle: '',
                                    noteTagsList: widget.noteTagsList,
                                  ),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.blueGrey,
                              size: 15.w,
                            ),
                          ),
                        )
                      : widget.noteTagsList.isEmpty
                          ? SizedBox(
                              height: 30.h,
                              child: Center(
                                child: Text(
                                  '"no tags added."',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16.w,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.transparent,
                              height: 30.h,
                            );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteTags(NoteStatusCubit _noteEditStore) {
    return Tags(
      key: _tagStateKey,
      itemCount: widget.noteTagsList.length,
      itemBuilder: (int index) {
        int borderColor = Database.tags[widget.noteTagsList[index]]!;

        return ItemTags(
          key: Key(index.toString()),
          elevation: 0,
          index: index,
          title: widget.noteTagsList[index],
          active: false,
          combine: ItemTagsCombine.withTextBefore,
          textStyle: TextStyle(
            fontSize: 14.w,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5.w,
          ),
          border: Border.all(color: Color(borderColor), width: 2),
          textActiveColor: Color(borderColor),
          textColor: Color(borderColor),
          activeColor: Colors.white,
          onPressed: (item) {
            if (_noteEditStore.state.isEditing) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => AddTagScreen(
                    controller: _tagController,
                    isEditing: true,
                    editTagTitle: item.title,
                    noteTagsList: widget.noteTagsList,
                  ),
                  fullscreenDialog: true,
                ),
              );
            }
          },
        );
      },
    );
  }
}
