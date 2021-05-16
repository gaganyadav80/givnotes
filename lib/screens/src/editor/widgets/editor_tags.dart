import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:givnotes/cubit/cubits.dart';

import '../editor_screen.dart';
import 'add_tags_page.dart';

class EditorTags extends StatefulWidget {
  EditorTags({Key key}) : super(key: key);

  @override
  _EditorTagsState createState() => _EditorTagsState();
}

class _EditorTagsState extends State<EditorTags> {
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  final TextEditingController _tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final NoteStatusCubit _noteEditStore = BlocProvider.of<NoteStatusCubit>(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildNoteTags(_noteEditStore),
            noteTagsMap.length == 0 ? SizedBox.shrink() : SizedBox(width: 10.w),
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
                                  updateTags: () => setState(() {}),
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
                    : noteTagsMap.length == 0
                        ? Container(
                            height: 30.h,
                            child: Center(
                              child: Text(
                                '"no tags added."',
                                style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  color: Colors.black.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 19.w,
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
    );
  }

  Widget _buildNoteTags(NoteStatusCubit _noteEditStore) {
    final List<String> noteTag = noteTagsMap.keys.toList();

    return Tags(
      key: _tagStateKey,
      itemCount: noteTagsMap.length,
      itemBuilder: (int index) {
        int borderColor = noteTagsMap[noteTag[index]];
        return ItemTags(
          key: Key(index.toString()),
          elevation: 0,
          index: index,
          title: noteTag[index],
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
          //
          // removeButton: ItemTagsRemoveButton(
          //   backgroundColor: Color(_noteTagColors[index]),
          //   onRemoved: () {
          //     if (Var.isEditing) {
          //       setState(() {
          //         _noteTags.removeAt(index);
          //       });
          //     } else {
          //       showToast("Read only mode");
          //     }
          //     return true;
          //   },
          // ),
          onPressed: (item) {
            if (_noteEditStore.state.isEditing) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => AddTagScreen(
                    controller: _tagController,
                    isEditing: true,
                    editTagTitle: item.title,
                    updateTags: () => setState(() {}),
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
