import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_tags/flutter_tags.dart';
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
  int _animateIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final NoteAndSearchCubit _noteEditStore = BlocProvider.of<NoteAndSearchCubit>(context);

    return Column(
      children: [
        // Text(
        //   'Search',
        //   style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
        // ),
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
                    // List<String> lst = [];

                    // _tagStateKey.currentState.getAllItem.where((a) => a.active == true).forEach((a) => lst.add(a.title));
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
                              Image.asset(
                                isDark ? 'assets/giv_img/search_dark.png' : 'assets/giv_img/search_light.png',
                                height: 150.h,
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

                    return AnimationLimiter(
                      child: ListView.builder(
                        itemCount: _notes.length,
                        itemBuilder: (context, index) {
                          _animateIndex = index;
                          index = _notes.length - index - 1;

                          var note = _notes[index];

                          _created = DateFormat.yMMMd().format(note.created);

                          return AnimationConfiguration.staggeredList(
                            position: _animateIndex,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 25.0,
                              child: FadeInAnimation(
                                child: InkWell(
                                  onTap: () {
                                    _noteEditStore.updateNoteMode(NoteMode.Editing);
                                    Navigator.pushNamed(context, RouterName.editorRoute,
                                        arguments: [NoteMode.Editing, note]);
                                  },
                                  child: Card(
                                    elevation: 0,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
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
                                              // fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          SizedBox(height: 10.0.h),
                                          Divider(height: 0.0, thickness: 1.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
  // final _TagsViewState tagsViewState;

  @override
  _SearchTagsTextFieldState createState() => _SearchTagsTextFieldState();
}

class _SearchTagsTextFieldState extends State<SearchTagsTextField> {
  final Map<String, int> _allTagsMap = prefsBox.allTagsMap;
  // bool editTags = false;

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
    // final hm = 7.6;

    return Column(
      children: [
        TextField(
          focusNode: _searchTagFocus,
          controller: _searchTagController,
          autocorrect: false,
          // cursorColor: Theme.of(context).textTheme.bodyText2.color,
          style: TextStyle(
            fontSize: 13,
            letterSpacing: 1.05,
            color: Colors.grey[800],
          ),
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            TextInputFormatter.withFunction(
              (oldValue, newValue) => TextEditingValue(
                text: newValue.text?.toUpperCase(),
                selection: newValue.selection,
              ),
            ),
          ],
          onEditingComplete: () {
            _searchTagFocus.unfocus();
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Colors.black,
            ),
            suffixIcon: InkWell(
              onTap: () {
                _tagSearchStore.clearTagSearchList();
                _tagSearchStore.updateTagSearchList(_allTagsMap.keys.toList());

                _searchTagController.clear();
                _searchTagFocus.unfocus();
              },
              child: Icon(
                Icons.close,
                size: 22,
                color: Colors.black,
              ),
            ),
            border: InputBorder.none,
            hintText: 'Search Tags',
            hintStyle: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.grey,
              fontSize: 14,
            ),
            contentPadding: EdgeInsets.only(
              left: 16.w,
              right: 20.w,
              top: 14.w,
              bottom: 14.w,
            ),
          ),
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
                // padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
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
