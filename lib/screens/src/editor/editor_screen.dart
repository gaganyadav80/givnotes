import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/models/documents/document.dart' as qd;
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/global/variables.dart';

import 'widgets/editor_widgets.dart';

Map<String, int> noteTagsMap = {};

class EditorScreen extends StatefulWidget {
  EditorScreen({Key key, this.noteMode, this.note}) : super(key: key);

  final NoteMode noteMode;
  final NotesModel note;

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final Rx<QuillController> _quillController = QuillController.basic().obs;

  final HiveDBServices _dbServices = HiveDBServices();
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _editorfocusNode = FocusNode();

  // final GlobalKey<ScaffoldState> _editorScaffoldKey = GlobalKey();

  dynamic _noteIndex;
  NoteStatusCubit _noteEditStore;
  ValueNotifier<NotesModel> _notesModel = ValueNotifier<NotesModel>(null);

  Future<qd.Document> _loadDocument() async {
    final contents = widget.note.znote;

    return qd.Document.fromJson(jsonDecode(contents));
  }

  @override
  void initState() {
    super.initState();

    if (BlocProvider.of<NoteStatusCubit>(context).state.noteMode == NoteMode.Editing) {
      _loadDocument().then((data) {
        // setState(() {
        _quillController.value = QuillController(
          document: data,
          selection: TextSelection.collapsed(offset: 0),
        );
        // });
      });
    }

    if (widget.noteMode == NoteMode.Adding) {
      _titleFocus.requestFocus();
      noteTagsMap = {};
    } else if (widget.noteMode == NoteMode.Editing) {
      noteTagsMap = widget.note.tagsMap;
      _noteIndex = widget.note.key;

      _notesModel.value = widget.note;
    }

    _editorfocusNode.unfocus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (BlocProvider.of<NoteStatusCubit>(context).state.noteMode == NoteMode.Editing) {
      _titleController.text = widget.note.title;
    }
  }

  @override
  void dispose() {
    noteTagsMap = {};
    _editorfocusNode?.dispose();
    _titleController?.dispose();
    _titleFocus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _noteEditStore = BlocProvider.of<NoteStatusCubit>(context);

    return WillPopScope(
      onWillPop: _onPop,
      child: Scaffold(
        // key: _editorScaffoldKey,
        backgroundColor: Colors.white,
        appBar: NoteEditorAppBar(saveNote: _saveNote),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: getTitleTextField(),
              ),
              SizedBox(height: 5.w),
              _noteEditStore.state.noteMode == NoteMode.Editing
                  ? ValueListenableBuilder(
                      valueListenable: _notesModel,
                      builder: (BuildContext context, NotesModel value, Widget child) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Text(
                            'modified ${DateFormat.yMMMd().add_Hm().format(value.modified)}',
                            style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              color: Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.w400,
                              fontSize: 16.h,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 10.w),
              EditorTags(),
              SizedBox(height: 15.w),
              Expanded(
                child: _editorBody(),
              ),
              BlocBuilder<NoteStatusCubit, NoteStatusState>(
                builder: (context, state) {
                  return Container(
                    width: double.infinity,
                    child: state.isEditing
                        ? QuillToolbar.basic(
                            controller: _quillController.value,
                            showBackgroundColorButton: false,
                            showClearFormat: false,
                            showHorizontalRule: false,
                            showListCheck: false,
                            toolbarIconSize: 22.0.w,
                          )
                        : SizedBox.shrink(),
                  );
                },
              )
            ],
          ),
        ),
        endDrawer: EditorEndDrawer(
          note: _notesModel.value,
          saveNote: _saveNote,
        ),
        floatingActionButton: BlocBuilder<NoteStatusCubit, NoteStatusState>(
          bloc: _noteEditStore,
          builder: (context, state) {
            return state.noteMode == NoteMode.Editing && !state.isEditing
                ? Container(
                    margin: EdgeInsets.only(bottom: 15.h),
                    child: FloatingActionButton(
                      heroTag: 'parent',
                      tooltip: 'Edit',
                      backgroundColor: Colors.black,
                      elevation: 5,
                      child: Icon(CupertinoIcons.pencil, color: Colors.white),
                      onPressed: () => _noteEditStore.updateIsEditing(true),
                    ),
                  )
                : SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _editorBody() {
    return BlocBuilder<NoteStatusCubit, NoteStatusState>(
      builder: (context, state) {
        return (_quillController.value == null)
            ? Center(child: CupertinoActivityIndicator())
            : Obx(() => QuillEditor(
                  controller: _quillController.value,
                  focusNode: _editorfocusNode,
                  scrollController: ScrollController(),
                  scrollable: true,
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  autoFocus: false,
                  readOnly: !(state.isEditing || state.noteMode == NoteMode.Adding),
                  expands: true,
                  showCursor: state.isEditing || state.noteMode == NoteMode.Adding,
                  placeholder: "Your Note here...",
                ));
      },
    );
  }

  Widget getTitleTextField() {
    return BlocBuilder<NoteStatusCubit, NoteStatusState>(
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
              fontSize: 35.w,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          style: TextStyle(
            fontFamily: 'ZillaSlab',
            fontSize: 35.w,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            _editorfocusNode.requestFocus();
          },
        );
      },
    );
  }

  Future<bool> _onPop() async {
    FocusScope.of(context).unfocus();

    String title = _titleController.text;
    String note = _quillController.value.document.toPlainText().trim();

    if (title.isEmpty && note.isEmpty) {
      showToast("Can't create empty note");

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
      String _note = _quillController.value.document.toPlainText().trim();

      if (_title.isEmpty && _note.isEmpty) {
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
        showToast("Can't create empty note");
        _noteEditStore.updateIsEditing(false);
        _noteEditStore.updateNoteMode(NoteMode.Adding);
      } else {
        FocusScope.of(context).unfocus();
        _noteEditStore.updateIsEditing(false);

        if (_noteEditStore.state.noteMode == NoteMode.Adding) {
          _notesModel.value = await _dbServices.insertNote(
            NotesModel()
              ..id = Uuid().v1()
              ..title = _title.isNotEmpty ? _title : 'Untitled'
              ..text = _note
              ..znote = jsonEncode(_quillController.value.document.toDelta().toJson())
              ..created = DateTime.now()
              ..modified = DateTime.now()
              ..tagsMap = noteTagsMap,
          );
          //
        } else if (_noteEditStore.state.noteMode == NoteMode.Editing) {
          _notesModel.value = await _dbServices.updateNote(
            _noteIndex,
            NotesModel()
              ..id = _notesModel.value.id
              ..title = _title.isNotEmpty ? _title : 'Untitled'
              ..text = _note
              ..znote = jsonEncode(_quillController.value.document.toDelta().toJson())
              ..trash = _notesModel.value.trash
              ..created = _notesModel.value.created
              ..modified = DateTime.now()
              ..tagsMap = noteTagsMap,
          );
        }

        showToast('Note saved succesfully');
      }
    }
  }

  void showToast(String msg) {
    Fluttertoast.showToast(msg: msg);
  }
}
