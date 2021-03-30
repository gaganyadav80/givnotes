import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'package:givnotes/cubit/note_search_cubit/note_search_cubit.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/global/size_utils.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/screens/themes/app_themes.dart';

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

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: giveStatusBarColor(context),
      ),
    );
    // final NoteAndSearchCubit _noteEditStore = BlocProvider.of<NoteAndSearchCubit>(context);

    return Column(
      children: [
        // Text(
        //   'Search',
        //   style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
        // ),
        Padding(
          // padding: EdgeInsets.fromLTRB(3 * wm, 1.5 * hm, 3 * wm, 0),
          padding: EdgeInsets.fromLTRB(0.025 * screenSize.width, 0.020 * screenSize.height, 0.025 * screenSize.width, 0),
          child: SearchTagsTextField(tagStateKey: _tagStateKey),
        ),
        /*
          Build Notes
         */
        Expanded(
          child: Padding(
            // padding: EdgeInsets.fromLTRB(1.5 * wm, 0, 1.5 * wm, 0),
            padding: EdgeInsets.symmetric(horizontal: 0.015 * screenSize.width),
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
                          // padding: EdgeInsets.fromLTRB(5 * wm, 2 * hm, 5 * wm, 0),
                          padding: EdgeInsets.fromLTRB(0.05 * screenSize.width, 0.02 * screenSize.height, 0.05 * screenSize.height, 0),
                          child: Column(
                            children: [
                              Image.asset(
                                isDark ? 'assets/giv_img/search_dark.png' : 'assets/giv_img/search_light.png',
                                // height: 40 * hm,

                                height: 0.2 * screenSize.height,
                              ),
                              Text(
                                'Search according the tags here',
                                style: TextStyle(
                                  fontSize: 12,
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
                                    // _noteEditStore.updateNoteMode(NoteMode.Editing);

                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => ZefyrEdit(
                                    //       noteMode: NoteMode.Editing,
                                    //       note: note,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Card(
                                    elevation: 0,
                                    color: Colors.white,
                                    child: Padding(
                                      // padding: EdgeInsets.symmetric(horizontal: 1.5 * wm),
                                      padding: EdgeInsets.symmetric(horizontal: 0.015 * screenSize.width),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Divider(
                                            // height: 0.057 * wm,
                                            height: 0.0002955 * screenSize.height,
                                            color: Colors.black,
                                          ),
                                          // SizedBox(height: 2 * wm),
                                          SizedBox(height: 0.010368421 * screenSize.height),
                                          Text(
                                            note.title,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          // SizedBox(height: 1 * wm),
                                          SizedBox(height: 0.005184211 * screenSize.height),
                                          Text(
                                            note.text,
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              // fontSize: 3 * wm,
                                            ),
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          // SizedBox(height: wm),
                                          SizedBox(height: 0.005184211 * screenSize.height),
                                          Text(
                                            "created  $_created",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey,
                                              fontSize: 12,
                                              // fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          // SizedBox(height: 1.5 * wm),
                                          SizedBox(height: 0.007776316 * screenSize.height),
                                          Divider(
                                            // height: 0.057 * wm,
                                            height: 0.0002955 * screenSize.height,
                                            color: Colors.black,
                                          ),
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
  }

  @override
  Widget build(BuildContext context) {
    final NoteAndSearchCubit _tagSearchStore = BlocProvider.of<NoteAndSearchCubit>(context);
    final hm = 7.6;

    return Column(
      children: [
        TextField(
          focusNode: _searchTagFocus,
          controller: _searchTagController,
          autocorrect: false,
          cursorColor: Theme.of(context).textTheme.bodyText2.color,
          style: TextStyle(
            fontSize: 13,
            letterSpacing: 1.05,
            // color: Colors.grey[800],
            color: Theme.of(context).textTheme.bodyText1.color,
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
            fillColor: Colors.black,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Colors.blue,
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
                color: Theme.of(context).textTheme.bodyText2.color,
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
              left: 0.030609137 * screenSize.width, //16
              right: 0.040761421 * screenSize.width, //20
              top: 0.008421053 * screenSize.height, //14
              bottom: 0.008421053 * screenSize.height, //14
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
                color: Colors.blue,
                key: Key(index.toString()),
                elevation: 2,
                index: index,
                title: noteTag,
                active: false,
                // padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                padding: EdgeInsets.fromLTRB(
                  0.038071066 * screenSize.width,
                  0.009210526 * screenSize.height,
                  0.038071066 * screenSize.width,
                  0.009210526 * screenSize.height,
                ),
                textStyle: TextStyle(
                  fontSize: 1.8 * hm,
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
                onLongPressed: (item) {
                  // setState(() {
                  // _items.removeAt(index);
                  // });
                  // showToast("Not Available yet.");
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
