import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:givnotes/widgets/search_text_field.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/cubit/note_search_cubit/note_search_cubit.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/routes.dart';

class TagsView extends StatefulWidget {
  @override
  _TagsViewState createState() => _TagsViewState();
}

class _TagsViewState extends State<TagsView> {
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  List<NotesModel> _notes = <NotesModel>[];
  String _created;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final NoteAndSearchCubit _noteEditStore = BlocProvider.of<NoteAndSearchCubit>(context);

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
            child: BlocBuilder<NoteAndSearchCubit, NoteAndSearchState>(
              builder: (context, state) {
                return ValueListenableBuilder(
                  valueListenable: Hive.box<NotesModel>('givnotes').listenable(),
                  builder: (context, Box<NotesModel> box, widget) {

                    _notes = box.values.where((element) {
                      return (element.trash == false) &&
                          state.selectedTagList.any((title) {
                            return element.tagsMap.containsKey(title);
                          });
                    }).toList();

                    if (_notes.length == 0) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(20.0.w),
                          child: Column(
                            children: [
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
                            elevation: 0,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  index == 0 ? Divider(height: 0.0, thickness: 1.0) : SizedBox.shrink(),
                                  SizedBox(height: 5.h),
                                  Text(
                                    note.title,
                                    style: TextStyle(
                                      fontSize: 17.w,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 1.sw / 100),
                                  Text(
                                    note.text,
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 12.w,
                                    ),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 1.sw / 100),
                                  Text(
                                    "created  $_created",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey,
                                      fontSize: 12.w,
                                    ),
                                  ),
                                  SizedBox(height: 10.0.h),
                                  Divider(height: 0.0, thickness: 1.0),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
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

  @override
  void initState() {
    super.initState();

    final NoteAndSearchCubit _tagSearchStore = BlocProvider.of<NoteAndSearchCubit>(context);

    _tagSearchStore.updateTagSearchList(_allTagsMap.keys.toList());

    _searchTagController.addListener(() {
      final text = _searchTagController.text;

      if (text.isNotEmpty) {
        _tagSearchStore.clearTagSearchList();

        final _filterList = _allTagsMap.keys.toList().where((element) {
          return element.toLowerCase().contains(text.toLowerCase());
        }).toList();

        if (_filterList == null) {
          throw Exception('List cannot be null');
        }
        _tagSearchStore.updateTagSearchList(_filterList);
      } else if (text.isEmpty) {
        _tagSearchStore.clearTagSearchList();
        _tagSearchStore.updateTagSearchList(_allTagsMap.keys.toList());
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
    final NoteAndSearchCubit _tagSearchStore = BlocProvider.of<NoteAndSearchCubit>(context);

    return Column(
      children: [
        CustomSearchTextField(
          controller: _searchTagController,
          focusNode: _searchTagFocus,
          useCapitals: true,
          // prefixSize: 18.0,
          placeholder: 'Search tags',
          padding: EdgeInsets.fromLTRB(8.w, 10.w, 0, 10.w),
          onClearTap: () {
            _tagSearchStore.clearTagSearchList();
            _tagSearchStore.updateTagSearchList(_allTagsMap.keys.toList());

            _searchTagController.clear();
            _searchTagFocus.unfocus();
          },
          onSubmitted: (_) {
            _searchTagFocus.unfocus();
          },
        ),
        BlocBuilder<NoteAndSearchCubit, NoteAndSearchState>(
          builder: (context, state) => Tags(
            key: widget.tagStateKey,
            itemCount: state.tagSearchList.length,
            horizontalScroll: true,
            itemBuilder: (int index) {
              final noteTag = state.tagSearchList[index];

              return ItemTags(
                key: Key(index.toString()),
                elevation: 2,
                index: index,
                title: noteTag,
                active: false,
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
                    _tagSearchStore.addSelectedTagList(item.title);
                  } else {
                    _tagSearchStore.removeSelectedTagList(item.title);
                  }
                  //FIXME idk how?
                  // widget.tagsViewState.setState(() {});
                },
              );
            },
          ),
        ),
      ],
    );
  }
}