import 'dart:convert';
import 'dart:math';

import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:givnotes/database/HiveDB.dart';
import 'package:givnotes/database/hive_db_helper.dart';
import 'package:givnotes/packages/zefyr-1.0.0/zefyr.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/variables/prefs.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/customAppBar.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

enum NoteMode { Editing, Adding }

class ZefyrEdit extends StatefulWidget {
  ZefyrEdit({this.noteMode, this.note});

  final NoteMode noteMode;
  final NotesModel note;

  @override
  _ZefyrEditState createState() => _ZefyrEditState();
}

class _ZefyrEditState extends State<ZefyrEdit> {
  HiveDBServices _dbServices;
  final FlareControls controls = FlareControls();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _newTagTextController = TextEditingController();
  final FocusNode _zefyrfocusNode = FocusNode();
  final FocusNode _titleFocus = FocusNode();
  ZefyrController _zefyrController = ZefyrController();

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  List<String> _noteTags = <String>[];
  List<int> _noteTagColors = [];
  List<String> _allTags = [];
  List<int> _allTagColors = [];

  Future<NotusDocument> _loadDocument() async {
    if (Var.noteMode == NoteMode.Editing) {
      final contents = widget.note.znote;
      return NotusDocument.fromJson(jsonDecode(contents));
    }

    // Delta delta = Delta()..insert("\n");
    // return NotusDocument.fromDelta(delta);
    //TODO check this
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
    } else if (widget.noteMode == NoteMode.Editing) {
      _noteTags = widget.note.tags;
      _noteTagColors = widget.note.tagColor;
    }

    _dbServices = HiveDBServices();
    _zefyrfocusNode.unfocus();

    _allTags = (prefsBox.get('allTags') as List).cast<String>();
    _allTagColors = (prefsBox.get('tagColors') as List).cast<int>();
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
    prefsBox.put('allTags', _allTags);
    prefsBox.put('tagColors', _allTagColors);

    _zefyrController?.dispose();
    _zefyrfocusNode?.dispose();
    _titleController?.dispose();
    _newTagTextController?.dispose();
    _titleFocus?.dispose();
    super.dispose();
  }

  void updateEditMode(bool value) {
    setState(() {
      Var.isEditing = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool editMode = (Var.isEditing || (Var.noteMode == NoteMode.Adding));

    //TODO copy zefyr to packages and customize
    // and add a fontFamily parameter to ZefyrThemeData
    final ZefyrThemeData _zefyrThemeData = ZefyrThemeData(
      bold: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'SFPro'),
      italic: TextStyle(fontStyle: FontStyle.italic, fontFamily: 'SFPro'),
      paragraph: TextBlockTheme(
        style: TextStyle(
          fontSize: 16,
          height: 1.3,
          color: Colors.black,
        ),
        spacing: VerticalSpacing(top: 6.0),
      ),
      heading1: TextBlockTheme(
        style: TextStyle(
          fontSize: 34.0,
          color: Colors.black.withOpacity(0.7),
          height: 1.15,
          fontWeight: FontWeight.w300,
        ),
        spacing: VerticalSpacing(top: 20.0),
      ),
      heading2: TextBlockTheme(
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.black.withOpacity(0.7),
          height: 1.15,
          fontWeight: FontWeight.normal,
        ),
        spacing: VerticalSpacing(top: 8.0),
      ),
      heading3: TextBlockTheme(
        style: TextStyle(
          fontFamily: 'SFMono',
          fontSize: 20.0,
          color: Colors.black.withOpacity(0.7),
          height: 1.25,
          fontWeight: FontWeight.w500,
        ),
        spacing: VerticalSpacing(top: 8.0),
      ),
      code: TextBlockTheme(
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'SFMono',
          fontSize: 14,
          height: 1.15,
        ),
        spacing: VerticalSpacing(top: 0.0),
        decoration: BoxDecoration(
          color: Colors.grey[800].withOpacity(1),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );

    final Widget _editorBody = (_zefyrController == null)
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          )
        : ZefyrTheme(
            data: _zefyrThemeData,
            child: ZefyrField(
              expands: true,
              showCursor: editMode,
              readOnly: !editMode,
              autofocus: false,
              controller: _zefyrController,
              focusNode: _zefyrfocusNode,
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              decoration: InputDecoration(
                hintText: '     Your Note here...',
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
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        extendBody: true,
        backgroundColor: Colors.white,
        appBar: ZefyrEditAppBar(
          saveNote: saveNote,
          controls: controls,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: getTitleTextField(),
              ),
              SizedBox(height: 1 * hm),
              widget.noteMode == NoteMode.Editing
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'modified ${DateFormat.yMMMd().add_Hm().format(widget.note.modified)}',
                        style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                          fontSize: 2.5 * hm,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 1 * hm),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    height: 4.8 * hm,
                    child: Row(
                      children: [
                        getNoteTags(),
                        _noteTags.length == 0 ? SizedBox.shrink() : SizedBox(width: 10),
                        editMode
                            ? Container(
                                height: 4.7 * hm,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.blueGrey,
                                    width: 2,
                                  ),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  onTap: () => showModalBottomSheet(
                                    context: context,
                                    builder: (context) => _addTagsBottomSheet(context),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.blueGrey,
                                    size: 3.4 * hm,
                                  ),
                                ),
                              )
                            : _noteTags.length == 0
                                ? Container(
                                    // color: Colors.orangeAccent,
                                    height: 4.8 * hm,
                                    child: Center(
                                      child: Text(
                                        '"no tags added"',
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
                                    height: 4.8 * hm,
                                  ),
                      ],
                    ),
                  ),
                ),
              ),
              // Divider(
              //   color: Colors.grey,
              //   indent: 15,
              //   endIndent: 15,
              //   thickness: 1,
              // ),
              Expanded(
                flex: 1,
                child: _editorBody,
              ),
              Container(
                width: double.infinity,
                child: editMode
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
          note: widget.note,
        ),
        floatingActionButton: Var.noteMode == NoteMode.Editing && !Var.isEditing
            ? Container(
                height: 18 * wm,
                margin: EdgeInsets.only(bottom: 5),
                child: FloatingActionButton(
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
    return Tags(
      key: _tagStateKey,
      itemCount: _noteTags.length,
      itemBuilder: (int index) {
        final noteTag = _noteTags[index];

        return ItemTags(
          key: Key(index.toString()),
          elevation: 0,
          index: index,
          //TODO remove uppercase
          title: noteTag.toUpperCase(),
          active: false,
          combine: ItemTagsCombine.withTextBefore,
          //
          padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
          textStyle: TextStyle(
            fontSize: 1.8 * hm,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          border: Border.all(color: Color(_noteTagColors[index]), width: 3),
          textActiveColor: Color(_noteTagColors[index]),
          textColor: Color(_noteTagColors[index]),
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
            _newTagTextController.text = item.title;
            return showModalBottomSheet(
              context: context,
              builder: (context) => _addTagsBottomSheet(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
            );
          },
        );
      },
    );
  }

  int colorIndex = Random().nextInt(10);
  int colorLength = 10;

  Container _addTagsBottomSheet(BuildContext context) {
    return Container(
      height: 55 * hm,
      padding: EdgeInsets.symmetric(horizontal: 3.5 * wm, vertical: 2.5 * hm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New tag',
            style: TextStyle(
              fontSize: 2.5 * hm,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _newTagTextController,
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
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              focusColor: Colors.grey,
              labelText: 'Tag name',
              labelStyle: TextStyle(
                fontSize: 2.2 * hm,
                fontWeight: FontWeight.bold,
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
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Tag color: ',
                style: TextStyle(
                  fontSize: 2.2 * hm,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 5),
              Container(
                height: 50,
                width: 70 * wm,
                color: Colors.transparent,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: colorLength,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          colorIndex = index;
                          colorLength = 1;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _newtagColors[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 40,
                width: 90,
                child: RaisedButton(
                  elevation: 0,
                  onPressed: () {
                    _newTagTextController.clear();
                    Navigator.pop(context);
                  },
                  color: Colors.grey[200],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: Color(0xff1F1F1F),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Container(
                height: 40,
                width: 90,
                child: RaisedButton(
                  elevation: 0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  onPressed: () {
                    int flag = 0;

                    if (_newTagTextController.text.isEmpty) {
                      showToast("Tag name is required");
                    } else {
                      if (!_allTags.contains(_newTagTextController.text)) {
                        _allTags.add(_newTagTextController.text);
                        _allTagColors.add(_newtagColors[colorIndex].value);
                      } else {
                        flag = _allTagColors.elementAt(_allTags.indexOf(_newTagTextController.text));
                      }

                      if (!_noteTags.contains(_newTagTextController.text)) {
                        _noteTags.add(_newTagTextController.text);

                        if (flag == 0)
                          _noteTagColors.add(_newtagColors[colorIndex].value);
                        else
                          _noteTagColors.add(flag);
                        //
                      } else {
                        showToast("Tag already added");
                      }
                      setState(() {});
                      _newTagTextController.clear();

                      Navigator.pop(context);
                    }
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<Color> _newtagColors = [
    Colors.orange,
    Colors.red,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.blueAccent,
    Colors.tealAccent,
    Colors.greenAccent,
    Colors.lightGreenAccent,
    Colors.yellowAccent,
    Colors.brown,
  ];

  Future<bool> _onPop() async {
    _titleFocus.unfocus();
    _zefyrfocusNode.unfocus();

    String title = _titleController.text;
    String note = _zefyrController.document.toPlainText().trim();
    if (title.isEmpty && note.isEmpty) {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              // title: Text('Note is Empty!'),
              content: Text("Your note is empty! Can't save it :)"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    Var.isEditing = false;
                  },
                  child: Text('Discard'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Edit'),
                ),
              ],
            ),
          )) ??
          false;
    } else if (title.isNotEmpty || note.isNotEmpty) {
      saveNote();
      //
    } else {
      updateEditMode(false);
    }
    return false;
  }

  void saveNote() async {
    if (Var.isEditing == false) {
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
          await _dbServices.insertNote(
            NotesModel()
              ..title = _title.isNotEmpty ? _title : 'Untitled'
              ..text = _note + '\n'
              ..znote = jsonEncode(_zefyrController.document)
              ..created = DateTime.now()
              ..modified = DateTime.now()
              ..tags = _noteTags
              ..tagColor = _noteTagColors,
          );

          showToast('Note saved');
          //
        } else if (Var.noteMode == NoteMode.Editing) {
          await _dbServices.updateNote(
            widget.note.key,
            NotesModel()
              ..title = _title.isNotEmpty ? _title : 'Untitled'
              ..text = _note + '\n'
              ..znote = jsonEncode(_zefyrController.document)
              ..trash = widget.note.trash
              ..created = widget.note.created
              ..modified = DateTime.now()
              ..tags = _noteTags
              ..tagColor = _noteTagColors,
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
