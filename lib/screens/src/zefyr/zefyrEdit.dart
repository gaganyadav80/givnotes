import 'dart:convert';

import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:givnotes/cubit/note_search_cubit/note_search_cubit.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/services/services.dart';
import 'package:intl/intl.dart';
import 'package:zefyr/zefyr.dart';

import 'widgets/zefyr_widgets.dart';

//TODO rewrite from scratch

Map<String, int> noteTagsMap = {};

class ZefyrEdit extends StatefulWidget {
  ZefyrEdit({this.noteMode, this.note});

  final NoteMode noteMode;
  final NotesModel note;

  @override
  ZefyrEditState createState() => ZefyrEditState();
}

class ZefyrEditState extends State<ZefyrEdit> {
  final HiveDBServices _dbServices = HiveDBServices();
  final FlareControls controls = FlareControls();
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _zefyrfocusNode = FocusNode();

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  final GlobalKey<ScaffoldState> _zefyrScaffoldKey = GlobalKey();

  //TODO flag
  ZefyrController _zefyrController = ZefyrController();
  dynamic _noteIndex;
  // bool zefyrEditMode = false;
  NoteAndSearchCubit _noteEditStore;
  ValueNotifier<NotesModel> _notesModel = ValueNotifier<NotesModel>(null);

  final hm = 7.6;
  final wm = 3.94;

  Future<NotusDocument> _loadDocument() async {
    if (BlocProvider.of<NoteAndSearchCubit>(context).state.noteMode ==
        NoteMode.Editing) {
      final contents = widget.note.znote;
      return NotusDocument.fromJson(jsonDecode(contents));
    }
    return NotusDocument();
  }

  @override
  void initState() {
    super.initState();
    _loadDocument().then((document) {
      setState(() {
        //TODO flag
        // _noteEditStore.changeZefyrController(document);
        _zefyrController = ZefyrController(document);
      });
    });

    if (widget.noteMode == NoteMode.Adding) {
      _titleFocus.requestFocus();
      noteTagsMap = {};
    } else if (widget.noteMode == NoteMode.Editing) {
      noteTagsMap = widget.note.tagsMap;
      _noteIndex = widget.note.key;

      _notesModel.value = widget.note;
    }

    _zefyrfocusNode.unfocus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (BlocProvider.of<NoteAndSearchCubit>(context).state.noteMode ==
        NoteMode.Editing) {
      _titleController.text = widget.note.title;
    }
  }

  @override
  void dispose() {
    noteTagsMap = {};

    //TODO flag
    // _noteEditStore.zefyrController?.dispose();
    _zefyrfocusNode?.dispose();
    _titleController?.dispose();
    _titleFocus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _noteEditStore = BlocProvider.of<NoteAndSearchCubit>(context);
    // zefyrEditMode = ((_noteEditStore.state.isEditing ?? true) || (_noteEditStore.state.noteMode == NoteMode.Adding));
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onPop,
      child: Scaffold(
        key: _zefyrScaffoldKey,
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
              // SizedBox(height: wm),
              SizedBox(height: 0.00518421053 * size.height),
              _noteEditStore.state.noteMode == NoteMode.Editing
                  ? ValueListenableBuilder(
                      valueListenable: _notesModel,
                      builder: (BuildContext context, NotesModel value,
                          Widget child) {
                        return Padding(
                          // padding: const EdgeInsets.symmetric(horizontal: 15),
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.038071066 * size.width),
                          child: Text(
                            'modified ${DateFormat.yMMMd().add_Hm().format(value.modified)}',
                            style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              color: Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.w400,
                              fontSize: 2 * hm,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox.shrink(),
              // SizedBox(height: 1 * hm),
              SizedBox(height: 0.01 * size.height),
              Padding(
                // padding: EdgeInsets.symmetric(horizontal: 15),
                padding:
                    EdgeInsets.symmetric(horizontal: 0.038071066 * size.width),

                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      getNoteTags(),
                      noteTagsMap.length == 0
                          ? SizedBox.shrink()
                          // : SizedBox(width: 10),
                          : SizedBox(width: 0.0131578947 * size.width),
                      BlocBuilder<NoteAndSearchCubit, NoteAndSearchState>(
                        builder: (context, state) {
                          return state.isEditing
                              ? Container(
                                  height: 4.0 * hm,
                                  // height: 0.04 * size.height,
                                  // height: 0.08 * size.width,

                                  width: 8 * wm,
                                  // width: 0.08 * size.width,
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
                                      _titleFocus.unfocus();
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            insetPadding: EdgeInsets.all(10),
                                            title: Text('New tag'),
                                            // titlePadding: EdgeInsets.fromLTRB(
                                            //     15, 15, 15, 0),
                                            titlePadding: EdgeInsets.fromLTRB(
                                              0.038071066 * size.width,
                                              0.0197368421 * size.height,
                                              0.038071066 * size.width,
                                              0,
                                            ),
                                            titleTextStyle: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              letterSpacing: 0.5,
                                            ),
                                            // contentPadding: EdgeInsets.fromLTRB(
                                            //     15, 15, 15, 0),
                                            contentPadding: EdgeInsets.fromLTRB(
                                              0.038071066 * size.width,
                                              0.0197368421 * size.height,
                                              0.038071066 * size.width,
                                              0,
                                            ),
                                            content: BlocProvider(
                                              create: (_) =>
                                                  NoteAndSearchCubit(),
                                              child: AddTagsDialog(
                                                editNoteTag: false,
                                                editTagTitle: '',
                                              ),
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
                                      // height: 4 * hm,
                                      height: 0.04 * size.height,
                                      child: Center(
                                        child: Text(
                                          '"no tags added."',
                                          style: TextStyle(
                                            fontFamily: 'ZillaSlab',
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 2.5 * hm,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      color: Colors.transparent,
                                      // height: 4.0 * hm,
                                      height: 0.04 * size.height,
                                    );
                        },
                      )
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
              // SizedBox(height: 2 * wm),
              SizedBox(height: 0.0103684211 * size.height),
              Expanded(
                child: _editorBody(),
              ),
              BlocBuilder<NoteAndSearchCubit, NoteAndSearchState>(
                builder: (context, state) {
                  return Container(
                    width: double.infinity,
                    child: state.isEditing
                        ? ZefyrToolbar.basic(
                            controller: _zefyrController,
                          )
                        : SizedBox.shrink(),
                  );
                },
              )
            ],
          ),
        ),
        endDrawer: EndDrawerItems(
          note: _notesModel.value,
          saveNote: _saveNote,
        ),
        floatingActionButton:
            BlocBuilder<NoteAndSearchCubit, NoteAndSearchState>(
          cubit: _noteEditStore,
          builder: (context, state) {
            return state.noteMode == NoteMode.Editing && !state.isEditing
                ? Container(
                    // height: 18 * wm,
                    // margin: EdgeInsets.only(bottom: 15),
                    margin: EdgeInsets.only(bottom: 0.0197368421 * size.height),

                    child: FloatingActionButton(
                      heroTag: 'parent',
                      tooltip: 'Edit',
                      backgroundColor: Colors.black,
                      elevation: 5,
                      child: Icon(CupertinoIcons.pencil, color: Colors.white),
                      onPressed: () {
                        _noteEditStore.updateIsEditing(true);
                        controls.play('edit');
                        // controls.play('idle-tick');
                      },
                    ),
                  )
                : SizedBox.shrink();
          },
        ),
      ),
    );
  }
  // End of build above

  Widget _editorBody() {
    return BlocBuilder<NoteAndSearchCubit, NoteAndSearchState>(
      builder: (context, state) {
        Size size = MediaQuery.of(context).size;
        return (_zefyrController == null)
            ? Center(child: CupertinoActivityIndicator())
            : ZefyrTheme(
                data: zefyrThemeData,
                child: ZefyrField(
                  expands: true,
                  showCursor:
                      state.isEditing || state.noteMode == NoteMode.Adding,
                  readOnly:
                      !(state.isEditing || state.noteMode == NoteMode.Adding),
                  autofocus: false,
                  controller: _zefyrController,
                  focusNode: _zefyrfocusNode,
                  // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  decoration: InputDecoration(
                    // contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    contentPadding: EdgeInsets.fromLTRB(
                      0.03807166 * size.width,
                      0.00657894737 * size.height,
                      0.03807166 * size.width,
                      0.00657894737 * size.height,
                    ),

                    hintText: 'Your Note here...',
                    hintStyle: TextStyle(
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
      },
    );
  }

  Widget getTitleTextField() {
    return BlocBuilder<NoteAndSearchCubit, NoteAndSearchState>(
      builder: (context, state) {
        return TextField(
          readOnly: !state.isEditing,
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
      },
    );
  }

  Widget getNoteTags() {
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
            if (_noteEditStore.state.isEditing) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  Size size = MediaQuery.of(context).size;
                  return AlertDialog(
                    insetPadding: EdgeInsets.all(10),
                    title: Text('Edit tag'),
                    // titlePadding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    titlePadding: EdgeInsets.fromLTRB(
                      0.038071066 * size.width,
                      0.0197368421 * size.height,
                      0.038071066 * size.width,
                      0,
                    ),

                    titleTextStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                    // contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    contentPadding: EdgeInsets.fromLTRB(
                      0.038071066 * size.width,
                      0.0197368421 * size.height,
                      0.038071066 * size.width,
                      0,
                    ),

                    content: BlocProvider(
                      create: (_) =>
                          BlocProvider.of<NoteAndSearchCubit>(context),
                      child: AddTagsDialog(
                        editNoteTag: true,
                        editTagTitle: item.title,
                      ),
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
    FocusScope.of(context).unfocus();

    String title = _titleController.text;
    String note = _zefyrController.document.toPlainText().trim();

    if (title.isEmpty && note.isEmpty) {
      showSnackBar("Can't create empty note");

      _noteEditStore.updateIsEditing(false);
      _noteEditStore.updateNoteMode(NoteMode.Adding);

      return true;
    } else if (title.isNotEmpty || note.isNotEmpty) {
      _saveNote();
      //
    }
    return false;
  }

  void _saveNote({bool isDrawerSave = false}) async {
    if (_noteEditStore.state.isEditing == false && isDrawerSave == false) {
      //
      _noteEditStore.updateNoteMode(NoteMode.Adding);
      Navigator.pop(context);
      //
    } else if (_noteEditStore.state.isEditing) {
      String _title = _titleController.text;
      String _note = _zefyrController.document.toPlainText().trim();

      if (_title.isEmpty && _note.isEmpty) {
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
        showSnackBar("Can't create empty note");
        _noteEditStore.updateIsEditing(false);
        _noteEditStore.updateNoteMode(NoteMode.Adding);
      } else {
        FocusScope.of(context).unfocus();
        controls.play('save');
        _noteEditStore.updateIsEditing(false);

        if (_noteEditStore.state.noteMode == NoteMode.Adding) {
          _notesModel.value = await _dbServices.insertNote(
            NotesModel()
              ..title = _title.isNotEmpty ? _title : 'Untitled'
              ..text = _note
              ..znote = jsonEncode(_zefyrController.document)
              ..created = DateTime.now()
              ..modified = DateTime.now()
              ..tagsMap = noteTagsMap,
          );
          //
        } else if (_noteEditStore.state.noteMode == NoteMode.Editing) {
          _notesModel.value = await _dbServices.updateNote(
            _noteIndex,
            NotesModel()
              ..title = _title.isNotEmpty ? _title : 'Untitled'
              ..text = _note
              ..znote = jsonEncode(_zefyrController.document)
              ..trash = _notesModel.value.trash
              ..created = _notesModel.value.created
              ..modified = DateTime.now()
              ..tagsMap = noteTagsMap,
          );
        }

        showSnackBar('Note saved succesfully');
      }
    }
  }

  void showSnackBar(String msg) {
    Toast.show(msg, context, duration: 3);
  }

  // End of widget
}
