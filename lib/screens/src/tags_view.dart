import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/src/notes/src/notes_repository.dart';
import 'package:givnotes/services/services.dart';

import 'notes/src/notes_model.dart';

class TagSearchController extends GetxController {
  List<String> tagSearchList = <String>[];
  List<String> selectedTagList = <String>[];

  void resetSearchList() {
    this.tagSearchList
      ..clear()
      ..addAll(VariableService().prefsBox.allTagsMap.keys.toList());

    update(['tagSearchList']);
  }

  void clearSearchListNOUP() => this.tagSearchList.clear();

  void addAllSearchList(List<String> value) {
    this.tagSearchList
      ..clear()
      ..addAll(value);
    update(['tagSearchList']);
  }

  void addSelectedList(String value) {
    this.selectedTagList.add(value);
    update(['selectedTagList']);
  }

  void removeSelectedList(String value) {
    this.selectedTagList.remove(value);
    update(['selectedTagList']);
  }
}

class TagsView extends StatefulWidget {
  @override
  _TagsViewState createState() => _TagsViewState();
}

class _TagsViewState extends State<TagsView> {
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  List<NotesModel> _notes = <NotesModel>[];
  String _created;

  @override
  void initState() {
    super.initState();
    Get.find<TagSearchController>().tagSearchList
      ..clear()
      ..addAll(VariableService().prefsBox.allTagsMap.keys.toList());
  }

  @override
  Widget build(BuildContext context) {
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
            child: GetBuilder<TagSearchController>(
              // init: TagSearchController(),
              id: 'selectedTagList',
              builder: (TagSearchController controller) {
                _notes = Get.find<NotesController>().notes.where((element) {
                  return (element.trash == false) &&
                      controller.selectedTagList.any((tag) {
                        return element.tags.contains(tag);
                      });
                }).toList();

                if (controller.selectedTagList.length == 0) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20.0.w),
                      child: Column(
                        children: [
                          SizedBox(height: 50.h),
                          Image.asset('assets/giv_img/search_light.png', height: 180.h),
                          'Search according the tags here'.text.size(12.w).make(),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    // index = _notes.length - index - 1;

                    NotesModel note = _notes[index];
                    _created = DateFormat.yMMMd().format(DateTime.parse(note.created));

                    return InkWell(
                      onTap: () {
                        _noteEditStore.updateNoteMode(NoteMode.Editing);
                        Navigator.pushNamed(context, RouterName.editorRoute, arguments: [NoteMode.Editing, note]);
                      },
                      child: Card(
                        elevation: 0.0,
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
  final Map<String, int> _allTagsMap = VariableService().prefsBox.allTagsMap;

  final TextEditingController _searchTagController = TextEditingController();
  final FocusNode _searchTagFocus = FocusNode();

  final TagSearchController _tagSearchController = Get.find<TagSearchController>();

  @override
  void initState() {
    super.initState();

    _searchTagController.addListener(() {
      final text = _searchTagController.text;

      if (text.isNotEmpty) {
        final _filterList = _allTagsMap.keys.toList().where((element) {
          return element.toLowerCase().contains(text.toLowerCase());
        }).toList();

        if (_filterList == null) {
          throw Exception('List cannot be null');
        }

        _tagSearchController.addAllSearchList(_filterList);
      } else if (text.isEmpty) {
        _tagSearchController.resetSearchList();
      }
    });

    _searchTagFocus.addListener(() {
      if (BlocProvider.of<HomeCubit>(context).state != 2) {
        _searchTagFocus.unfocus();
      }
    });
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
            _tagSearchController.resetSearchList();

            _searchTagController.clear();
            _searchTagFocus.unfocus();
          },
          onSubmitted: (_) => _searchTagFocus.unfocus(),
        ),
        GetBuilder<TagSearchController>(
          id: 'tagSearchList',
          builder: (TagSearchController controller) => Tags(
            key: widget.tagStateKey,
            itemCount: controller.tagSearchList.length,
            horizontalScroll: true,
            itemBuilder: (int index) {
              final noteTag = controller.tagSearchList[index];

              return ItemTags(
                key: Key(index.toString()),
                elevation: 2,
                index: index,
                title: noteTag,
                active: controller.selectedTagList.contains(noteTag),
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
                onPressed: (item) {
                  if (item.active) {
                    controller.addSelectedList(item.title);
                  } else {
                    controller.removeSelectedList(item.title);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
