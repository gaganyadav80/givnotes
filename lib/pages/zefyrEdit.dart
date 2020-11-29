import 'dart:convert';

import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:givnotes/database/HiveDB.dart';
import 'package:givnotes/database/hive_db_helper.dart';
import 'package:givnotes/packages/toast.dart';
import 'package:givnotes/ui/addTagsDialog.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/variables/prefs.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/customAppBar.dart';
import 'package:intl/intl.dart';
import 'package:zefyr/zefyr.dart';

enum NoteMode { Editing, Adding }
Map<String, int> noteTagsMap = {};
// final GlobalKey<ScaffoldState> zefyrScaffoldKey = GlobalKey<ScaffoldState>();

class ZefyrEdit extends StatefulWidget {
  ZefyrEdit({this.noteMode, this.note});

  final NoteMode noteMode;
  final NotesModel note;

  @override
  ZefyrEditState createState() => ZefyrEditState();
}

class ZefyrEditState extends State<ZefyrEdit> {
  HiveDBServices _dbServices;
  final FlareControls controls = FlareControls();

  final TextEditingController _titleController = TextEditingController();
  // final TextEditingController _newTagTextController = TextEditingController();

  final FocusNode _zefyrfocusNode = FocusNode();
  final FocusNode _titleFocus = FocusNode();
  ZefyrController _zefyrController = ZefyrController();

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  // Map<String, int> _allTagsMap = {};

  dynamic _noteIndex;
  NotesModel _notesModel;

  Future<NotusDocument> _loadDocument() async {
    if (Var.noteMode == NoteMode.Editing) {
      final contents = widget.note.znote;
      return NotusDocument.fromJson(jsonDecode(contents));
    }

    // Delta delta = Delta()..insert("\n");
    // return NotusDocument.fromDelta(delta);
    return NotusDocument();
  }

  @override
  void initState() {
    super.initState();
    _loadDocument().then((document) {
      setState(() {
        _zefyrController = ZefyrController(document);
      });
    });

    if (widget.noteMode == NoteMode.Adding) {
      _titleFocus.requestFocus();
      noteTagsMap = {};
    } else if (widget.noteMode == NoteMode.Editing) {
      noteTagsMap = widget.note.tagsMap;
      _noteIndex = widget.note.key;

      _notesModel = widget.note;
    }

    _dbServices = HiveDBServices();
    _zefyrfocusNode.unfocus();
    // _dbServices.deleteNote(2);

    // _allTagsMap = (prefsBox.get('allTagsMap') as Map).cast<String, int>();
  }

  @override
  void didChangeDependencies() {
    if (Var.noteMode == NoteMode.Editing) {
      _titleController.text = widget.note.title;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // prefsBox.put('allTagsMap', _allTagsMap);
    noteTagsMap = {};

    _zefyrController?.dispose();
    _zefyrfocusNode?.dispose();
    _titleController?.dispose();
    // _newTagTextController?.dispose();
    _titleFocus?.dispose();
    super.dispose();
  }

  void updateEditMode(bool value) {
    setState(() {
      Var.isEditing = value;
    });
  }

  bool zefyrEditMode = false;
  // bool editNoteTag = false;
  // String editTagTitle = '';
  int randomTagColor;
  int colorValue = 0;

  @override
  Widget build(BuildContext context) {
    zefyrEditMode = (Var.isEditing || (Var.noteMode == NoteMode.Adding));

    final Widget _editorBody = (_zefyrController == null)
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          )
        : ZefyrTheme(
            data: zefyrThemeData, //TODO inside prefs.dart
            child: ZefyrField(
              expands: true,
              showCursor: zefyrEditMode,
              readOnly: !zefyrEditMode,
              autofocus: false,
              controller: _zefyrController,
              focusNode: _zefyrfocusNode,
              // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                hintText: 'Your Note here...',
                hintStyle: TextStyle(
                  fontFamily: 'SFPro',
                  fontSize: 2.3 * hm,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  gapPadding: 0,
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
          );

    return WillPopScope(
      onWillPop: _onPop,
      child: Scaffold(
        // key: zefyrScaffoldKey,
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        extendBody: true,
        backgroundColor: Colors.white,
        appBar: ZefyrEditAppBar(
          saveNote: _saveNote,
          controls: controls,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: getTitleTextField(),
              ),
              SizedBox(height: wm),
              widget.noteMode == NoteMode.Editing
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'modified ${DateFormat.yMMMd().add_Hm().format(_notesModel.modified)}',
                        style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                          fontSize: 2 * hm,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 1 * hm),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      getNoteTags(),
                      noteTagsMap.length == 0 ? SizedBox.shrink() : SizedBox(width: 10),
                      zefyrEditMode
                          ? Container(
                              height: 4.0 * hm,
                              width: 8 * wm,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blueGrey,
                                  width: 2,
                                ),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        insetPadding: EdgeInsets.all(10),
                                        title: Text('New tag'),
                                        titlePadding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                        titleTextStyle: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          letterSpacing: 0.5,
                                        ),
                                        contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                        content: AddTagsDialog(
                                          editNoteTag: false,
                                          editTagTitle: '',
                                          setZefyrState: updateEditMode,
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.add,
                                  color: Colors.blueGrey,
                                  size: 2 * hm,
                                ),
                              ),
                            )
                          : noteTagsMap.length == 0
                              ? Container(
                                  // color: Colors.orangeAccent,
                                  height: 4 * hm,
                                  child: Center(
                                    child: Text(
                                      // "Click on the edit button and then + to add new tags"
                                      '"no tags added."',
                                      style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        color: Colors.black.withOpacity(0.7),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 2.5 * hm,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  color: Colors.transparent,
                                  height: 4.0 * hm,
                                ),
                    ],
                  ),
                ),
              ),
              // Divider(
              //   color: Colors.grey,
              //   indent: 15,
              //   endIndent: 15,
              //   thickness: 1,
              // ),
              SizedBox(height: 2 * wm),
              Expanded(
                child: _editorBody,
              ),
              Container(
                width: double.infinity,
                child: zefyrEditMode
                    ? ZefyrToolbar.basic(
                        controller: _zefyrController,
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
        endDrawer: EndDrawerItems(
          titleController: _titleController,
          zefyrController: _zefyrController,
          updateZefyrEditMode: updateEditMode,
          controls: controls,
          note: _notesModel,
          noteTagsMap: noteTagsMap,
          noteIndex: _noteIndex,
          saveNote: _saveNote,
        ),
        floatingActionButton: Var.noteMode == NoteMode.Editing && !Var.isEditing
            ? Container(
                // height: 18 * wm,
                margin: EdgeInsets.only(bottom: 15),
                child: FloatingActionButton(
                  heroTag: 'parent',
                  tooltip: 'Edit',
                  backgroundColor: Colors.black,
                  elevation: 5,
                  child: Icon(CupertinoIcons.pencil, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      Var.isEditing = true;
                    });
                    controls.play('edit');
                    // controls.play('idle-tick');
                  },
                ),
              )
            : null,
      ),
    );
  }
  // End of build above

  Widget getTitleTextField() {
    return TextField(
      readOnly: !Var.isEditing,
      focusNode: _titleFocus,
      controller: _titleController,
      enableInteractiveSelection: true,
      enableSuggestions: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration.collapsed(
        hintText: 'Title',
        hintStyle: TextStyle(
          fontFamily: 'ZillaSlab',
          fontSize: 4.5 * hm,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: TextStyle(
        fontFamily: 'ZillaSlab',
        fontSize: 4.5 * hm,
        fontWeight: FontWeight.w600,
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        _zefyrfocusNode.requestFocus();
      },
    );
  }

  Widget getNoteTags() {
    final noteTag = noteTagsMap.keys.toList();

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
          //
          // padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
          textStyle: TextStyle(
            fontSize: 1.8 * hm,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
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
            if (zefyrEditMode) {
              // _newTagTextController.text = item.title;
              // editNoteTag = true;
              // editTagTitle = item.title;
              // colorValue = _allTagsMap[item.title];
              // selectTagColors
              //   ..clear()
              //   ..add(_allTagsMap[item.title]);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    insetPadding: EdgeInsets.all(10),
                    title: Text('Edit tag'),
                    titlePadding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    titleTextStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    content: AddTagsDialog(
                      editNoteTag: true,
                      editTagTitle: item.title,
                      setZefyrState: updateEditMode,
                    ),
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  Future<bool> _onPop() async {
    _titleFocus.unfocus();
    _zefyrfocusNode.unfocus();

    String title = _titleController.text;
    String note = _zefyrController.document.toPlainText().trim();
    if (title.isEmpty && note.isEmpty) {
      FocusScope.of(context).unfocus();
      showToast("Can't create empty note");

      Var.isEditing = false;
      Var.noteMode = NoteMode.Adding;

      return true;
    } else if (title.isNotEmpty || note.isNotEmpty) {
      _saveNote();
      //
    } else {
      updateEditMode(false);
    }
    return false;
  }

  void _saveNote({bool isDrawerSave = false}) async {
    if (Var.isEditing == false && isDrawerSave == false) {
      //
      Var.noteMode = NoteMode.Adding;
      Navigator.pop(context);
      //
    } else if (Var.isEditing) {
      String _title = _titleController.text;
      String _note = _zefyrController.document.toPlainText().trim();

      if (_title.isEmpty && _note.isEmpty) {
        //
        FocusScope.of(context).unfocus();
        showToast("Can't create empty note");
        Navigator.pop(context);
        Var.isEditing = false;
        //
      } else {
        //
        FocusScope.of(context).unfocus();
        controls.play('save');
        updateEditMode(false);

        if (Var.noteMode == NoteMode.Adding) {
          _notesModel = await _dbServices.insertNote(
            NotesModel()
              ..title = _title.isNotEmpty ? _title : 'Untitled'
              ..text = _note
              ..znote = jsonEncode(_zefyrController.document)
              ..created = DateTime.now()
              ..modified = DateTime.now()
              ..tagsMap = noteTagsMap,
          );

          showToast('Note saved');
          //
        } else if (Var.noteMode == NoteMode.Editing) {
          _notesModel = await _dbServices.updateNote(
            _noteIndex,
            NotesModel()
              ..title = _title.isNotEmpty ? _title : 'Untitled'
              ..text = _note
              ..znote = jsonEncode(_zefyrController.document)
              ..trash = _notesModel.trash
              ..created = _notesModel.created
              ..modified = DateTime.now()
              ..tagsMap = noteTagsMap,
          );

          showToast('Note saved');
        }
      }
    }
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

  // End of widget
}

// showModalBottomSheet(
//   context: context,
//   builder: (context) {
//     return CustomColorChoose(
//       editNoteTag: false,
//       editTagTitle: '',
//       setZefyrState: updateEditMode,
//     );
//   },
//   shape: RoundedRectangleBorder(
//     borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//   ),
// );
