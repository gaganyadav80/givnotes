import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/routes.dart';

class TagSearchController extends GetxController {
  final RxList<String> tagSearchList = <String>[].obs;
  final RxList<String> selectedTagList = <String>[].obs;
}

class TagsView extends StatefulWidget {
  @override
  _TagsViewState createState() => _TagsViewState();
}

class _TagsViewState extends State<TagsView> {
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  List<NotesModel> _notes = <NotesModel>[];
  String _created;
  final TagSearchController _tagSearchController = Get.find<TagSearchController>();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final NoteStatusCubit _noteEditStore = BlocProvider.of<NoteStatusCubit>(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10.w),
          child: SearchTagsTextField(tagStateKey: _tagStateKey),
        ),
        /*
          Build Notes
         */
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Obx(() {
              _notes = Hive.box<NotesModel>('givnotes').values.where((element) {
                return (element.trash == false) &&
                    _tagSearchController.selectedTagList.any((title) {
                      return element.tagsMap.containsKey(title);
                    });
              }).toList();

              if (_notes.length == 0) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20.0.w),
                    child: Column(
                      children: [
                        _tagSearchController.selectedTagList.length.text.xs.make().opacity0(),
                        SizedBox(height: 50.h),
                        Image.asset(
                          isDark ? 'assets/giv_img/search_dark.png' : 'assets/giv_img/search_light.png',
                          height: 180.h,
                        ),
                        Text(
                          'Search according the tags here',
                          style: TextStyle(
                            fontSize: 12.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  index = _notes.length - index - 1;

                  var note = _notes[index];

                  _created = DateFormat.yMMMd().format(note.created);

                  return InkWell(
                    onTap: () {
                      _noteEditStore.updateNoteMode(NoteMode.Editing);
                      Navigator.pushNamed(context, RouterName.editorRoute, arguments: [NoteMode.Editing, note]);
                    },
                    child: Card(
                      elevation: 0 ?? _tagSearchController.selectedTagList.length.text.xs.make().opacity0(),
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            index == _notes.length - 1 ? Divider(height: 0.0, thickness: 1.0) : SizedBox.shrink(),
                            SizedBox(height: 5.w),
                            Text(
                              note.title,
                              style: TextStyle(
                                fontSize: 17.w,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5.w),
                            Text(
                              note.text,
                              style: TextStyle(
                                color: Colors.grey[800],
                              ),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5.w),
                            Text(
                              "created  $_created",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                                fontSize: 12.w,
                              ),
                            ),
                            SizedBox(height: 10.0.w),
                            Divider(height: 0.0, thickness: 1.0),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}

class SearchTagsTextField extends StatefulWidget {
  SearchTagsTextField({Key key, this.tagStateKey}) : super(key: key);

  final GlobalKey<TagsState> tagStateKey;

  @override
  _SearchTagsTextFieldState createState() => _SearchTagsTextFieldState();
}

class _SearchTagsTextFieldState extends State<SearchTagsTextField> {
  final Map<String, int> _allTagsMap = prefsBox.allTagsMap;

  final TextEditingController _searchTagController = TextEditingController();
  final FocusNode _searchTagFocus = FocusNode();

  final TagSearchController _tagSearchController = Get.find<TagSearchController>();

  @override
  void initState() {
    super.initState();

    _tagSearchController.tagSearchList
      ..clear()
      ..addAll(_allTagsMap.keys.toList());

    _searchTagController.addListener(() {
      final text = _searchTagController.text;

      if (text.isNotEmpty) {
        _tagSearchController.tagSearchList.clear();

        final _filterList = _allTagsMap.keys.toList().where((element) {
          return element.toLowerCase().contains(text.toLowerCase());
        }).toList();

        if (_filterList == null) {
          throw Exception('List cannot be null');
        }

        _tagSearchController.tagSearchList
          ..clear()
          ..addAll(_filterList);
      } else if (text.isEmpty) {
        _tagSearchController.tagSearchList
          ..clear()
          ..addAll(_allTagsMap.keys.toList());
      }
    });

    _searchTagFocus.addListener(() {
      if (BlocProvider.of<HomeCubit>(context).state.index != 2) {
        _searchTagFocus.unfocus();
      }
    });
  }

  @override
  void dispose() {
    _searchTagFocus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoSearchTextField(
          controller: _searchTagController,
          focusNode: _searchTagFocus,
          prefixInsets: const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 4),
          placeholder: 'Search tags',
          onSuffixTap: () {
            _tagSearchController.tagSearchList
              ..clear()
              ..addAll(_allTagsMap.keys.toList());

            _searchTagController.clear();
            _searchTagFocus.unfocus();
          },
          onSubmitted: (_) {
            _searchTagFocus.unfocus();
          },
        ),
        Obx(() => Tags(
              key: widget.tagStateKey,
              itemCount: _tagSearchController.tagSearchList.length,
              horizontalScroll: true,
              itemBuilder: (int index) {
                final noteTag = _tagSearchController.tagSearchList[index];

                return ItemTags(
                  key: Key(index.toString()),
                  elevation: 2,
                  index: index,
                  title: noteTag,
                  active: _tagSearchController.selectedTagList.contains(noteTag),
                  padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
                  textStyle: TextStyle(
                    fontSize: 14.w,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),

                  border: Border.all(color: Color(_allTagsMap[noteTag]), width: 2),
                  textActiveColor: Colors.white,
                  textColor: Color(_allTagsMap[noteTag]),
                  combine: ItemTagsCombine.withTextBefore,
                  activeColor: Color(_allTagsMap[noteTag]),
                  //
                  //
                  // removeButton: ItemTagsRemoveButton(
                  //   backgroundColor: Color(_allTagColors[index]),
                  //   onRemoved: () {
                  //     showToast("Long press to delete Tag");
                  //     return true;
                  //   },
                  // ),
                  onPressed: (item) {
                    if (item.active) {
                      _tagSearchController.selectedTagList.add(item.title);
                    } else {
                      _tagSearchController.selectedTagList.remove(item.title);
                    }
                  },
                );
              },
            )),
      ],
    );
  }
}
