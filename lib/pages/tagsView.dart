import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:givnotes/database/HiveDB.dart';
import 'package:givnotes/packages/toast.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/variables/prefs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class TagsView extends StatefulWidget {
  @override
  _TagsViewState createState() => _TagsViewState();
}

class _TagsViewState extends State<TagsView> {
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  List<NotesModel> _notes = List<NotesModel>();
  String _created;
  // String _modified;

  List<String> lst = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(15, 1.5 * hm, 15, 0),
          child: SearchTagsTextField(
            tagStateKey: _tagStateKey,
            tagsViewState: this,
          ),
        ),
        /*
          Build Notes
         */
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(1.5 * wm, 0, 1.5 * wm, 0),
            child: ValueListenableBuilder(
              valueListenable: Hive.box<NotesModel>('givnnotes').listenable(),
              builder: (context, Box<NotesModel> box, widget) {
                lst.clear();

                _tagStateKey.currentState.getAllItem.where((a) => a.active == true).forEach((a) => lst.add(a.title));
                _notes = box.values.where((element) {
                  return (element.trash == Var.isTrash) &&
                      lst.any((title) {
                        return element.tagsMap.containsKey(title);
                      });
                }).toList();

                if (_notes.length == 0) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5 * wm, 2 * hm, 5 * wm, 0),
                      child: Image.asset('assets/images/tags-view-1.png'),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    index = _notes.length - index - 1;

                    var note = _notes[index];

                    _created = DateFormat.yMMMd().format(note.created);
                    // _modified = DateFormat.yMMMd().format(note.modified);

                    return InkWell(
                      onTap: () {
                        Var.noteMode = NoteMode.Editing;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ZefyrEdit(
                              noteMode: NoteMode.Editing,
                              note: note,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.5 * wm),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Divider(
                                height: 0.057 * wm,
                                color: Colors.black,
                              ),
                              SizedBox(height: 2 * wm),
                              Text(
                                note.title,
                                style: GoogleFonts.ubuntu(
                                  fontSize: 4.4 * wm,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 1 * wm),
                              Text(
                                note.text,
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  // fontSize: 3 * wm,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: wm),
                              Text(
                                "created  $_created",
                                style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey,
                                  fontSize: 3 * wm,
                                  // fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(height: 1.5 * wm),
                              Divider(
                                height: 0.057 * wm,
                                color: Colors.black,
                              ),
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

  void showToast(String msg) {
    Toast.show(
      msg,
      context,
      duration: 3,
      gravity: Toast.BOTTOM,
      backgroundColor: toastGrey,
      backgroundRadius: 5,
    );
  }
}

class SearchTagsTextField extends StatefulWidget {
  SearchTagsTextField({Key key, this.tagStateKey, this.tagsViewState}) : super(key: key);

  final GlobalKey<TagsState> tagStateKey;
  final _TagsViewState tagsViewState;

  @override
  _SearchTagsTextFieldState createState() => _SearchTagsTextFieldState();
}

class _SearchTagsTextFieldState extends State<SearchTagsTextField> {
  Map<String, int> _allTagsMap = {};
  // List<String> _allTags = [];
  // List<int> _allTagColors = [];
  bool editTags = false;

  TextEditingController _searchTagController = TextEditingController();
  FocusNode _searchTagFocus = FocusNode();
  List<String> _searchList = [];

  @override
  void initState() {
    super.initState();
    _allTagsMap = (prefsBox.get('allTagsMap') as Map).cast<String, int>();
    // _allTags = (prefsBox.get('allTags') as List).cast<String>();
    // _allTagColors = (prefsBox.get('tagColors') as List).cast<int>();

    // _searchList.addAll(_allTags);
    _searchList.addAll(_allTagsMap.keys);

    _searchTagController.addListener(() {
      final text = _searchTagController.text;

      if (text.isNotEmpty) {
        setState(() {
          _searchList.clear();

          final filterList = _allTagsMap.keys.toList().where((element) => element.toLowerCase().contains(text.toLowerCase())).toList();
          if (filterList == null) {
            throw Exception('List cannot be null');
          }
          _searchList.addAll(filterList);
        });
      } else if (text.isEmpty && _searchTagFocus.hasFocus) {
        setState(() {
          _searchList
            ..clear()
            ..addAll(_allTagsMap.keys);
        });
      }
    });
  }

  // @override
  // void didUpdateWidget(TagsView oldWidget) {
  //   if (oldWidget._all != widget.searchList) {
  //     init();
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          focusNode: _searchTagFocus,
          controller: _searchTagController,
          autocorrect: false,
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
            // SystemChannels.textInput.invokeMethod('TextInput.hide');
            _searchTagFocus.unfocus();
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            focusColor: Colors.grey,
            labelText: 'Search tag',
            labelStyle: TextStyle(
              fontSize: 2.2 * hm,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey[800],
                width: 2.5,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey[800],
                width: 2.5,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  _searchList
                    ..clear()
                    ..addAll(_allTagsMap.keys);
                });

                _searchTagController.clear();
                // SystemChannels.textInput.invokeMethod('TextInput.hide');
                _searchTagFocus.unfocus();
              },
              child: Icon(
                Icons.close,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
        Tags(
          key: widget.tagStateKey,
          itemCount: _searchList.length,
          horizontalScroll: true,
          itemBuilder: (int index) {
            final noteTag = _searchList[index];

            return ItemTags(
              key: Key(index.toString()),
              elevation: 2,
              index: index,
              title: noteTag,
              active: false,
              padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
              textStyle: TextStyle(
                fontSize: 1.8 * hm,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
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
                widget.tagsViewState.setState(() {});
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
      ],
    );
  }
}
