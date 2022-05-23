import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:givnotes/controllers/controllers.dart';
import 'package:givnotes/models/models.dart';
import 'package:givnotes/services/src/variables.dart';

import 'widgets/editor_widgets.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key, this.noteMode, this.note}) : super(key: key);

  final NoteMode? noteMode;
  final NotesModel? note;

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final Rx<quill.QuillController?> _quillController = quill.QuillController.basic().obs;

  // final HiveDBServices _dbServices = HiveDBServices();
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _editorfocusNode = FocusNode();
  final RxList<String> noteTagsList = <String>[].obs;

  // dynamic _noteIndex;
  // NoteStatusCubit? _noteEditStore;
  final ValueNotifier<NotesModel?> _notesModel = ValueNotifier<NotesModel?>(null);

  Future<quill.Document> _loadDocument() async {
    final contents = widget.note!.znote!;

    return quill.Document.fromJson(jsonDecode(contents));
  }

  @override
  void initState() {
    super.initState();

    if (NoteStatusController.to.noteMode == NoteMode.editing) {
      _loadDocument().then((data) {
        // setState(() {
        _quillController.value = quill.QuillController(
          document: data,
          selection: const TextSelection.collapsed(offset: 0),
        );
        // });
      });
    }

    if (widget.noteMode == NoteMode.adding) {
      _titleFocus.requestFocus();
      noteTagsList.clear();
    } else if (widget.noteMode == NoteMode.editing) {
      noteTagsList
        ..clear()
        ..addAll(widget.note!.tags);
      // _noteIndex = widget.note.key;

      _notesModel.value = widget.note;
    }

    _editorfocusNode.unfocus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (NoteStatusController.to.noteMode == NoteMode.editing) {
      _titleController.text = widget.note!.title!;
    }
  }

  @override
  void dispose() {
    noteTagsList.clear();
    _editorfocusNode.dispose();
    _titleController.dispose();
    _titleFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext rootContext) {
    // _noteEditStore = BlocProvider.of<NoteStatusCubit>(rootContext);

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
              NoteStatusController.to.noteMode == NoteMode.editing
                  ? ValueListenableBuilder(
                      valueListenable: _notesModel,
                      builder: (BuildContext context, NotesModel? value, Widget? child) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Text(
                            'modified ${DateFormat.yMMMd().add_Hm().format(DateTime.parse(value!.modified!))}',
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
                  : const SizedBox.shrink(),
              SizedBox(height: 10.w),
              EditorTags(noteTagsList: noteTagsList),
              SizedBox(height: 15.w),
              Expanded(
                child: _editorBody(),
              ),
              GetBuilder<NoteStatusController>(
                builder: (NoteStatusController controller) {
                  return SizedBox(
                    width: double.infinity,
                    child: controller.isEditing
                        ? quill.QuillToolbar.basic(
                            controller: _quillController.value!,
                            showBackgroundColorButton: false,
                            showClearFormat: false,
                            // showHorizontalRule: false,
                            showListCheck: false,
                            toolbarIconSize: 22.0.w,
                          )
                        : const SizedBox.shrink(),
                  );
                },
              )
            ],
          ),
        ),
        endDrawer: EditorEndDrawer(
          note: _notesModel.value,
          saveNote: _saveNote,
          rootCtx: rootContext,
        ),
        floatingActionButton: GetBuilder<NoteStatusController>(
          builder: (NoteStatusController controller) {
            return controller.noteMode == NoteMode.editing && !controller.isEditing
                ? Container(
                    margin: EdgeInsets.only(bottom: 15.h),
                    child: FloatingActionButton(
                      heroTag: 'parent',
                      tooltip: 'Edit',
                      backgroundColor: Colors.black,
                      elevation: 5,
                      child: const Icon(CupertinoIcons.pencil, color: Colors.white),
                      onPressed: () => controller.updateIsEditing(true),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _editorBody() {
    return GetBuilder<NoteStatusController>(
      builder: (NoteStatusController state) {
        return (_quillController.value == null)
            ? const Center(child: CupertinoActivityIndicator())
            : Obx(() => quill.QuillEditor(
                  controller: _quillController.value!,
                  focusNode: _editorfocusNode,
                  scrollController: ScrollController(),
                  scrollable: true,
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  autoFocus: false,
                  readOnly: !(state.isEditing || state.noteMode == NoteMode.adding),
                  expands: true,
                  showCursor: state.isEditing || state.noteMode == NoteMode.adding,
                  placeholder: "Your Note here...",
                ));
      },
    );
  }

  Widget getTitleTextField() {
    return GetBuilder<NoteStatusController>(
      builder: (NoteStatusController state) {
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
    String note = _quillController.value!.document.toPlainText().trim();

    if (title.isEmpty && note.isEmpty) {
      showToast("Can't create empty note");

      NoteStatusController.to.updateIsEditing(false);
      NoteStatusController.to.updateNoteMode(NoteMode.adding);

      return true;
    } else if (title.isNotEmpty || note.isNotEmpty) {
      _saveNote();
      //
    }
    return false;
  }

  void _saveNote({bool isDrawerSave = false}) async {
    if (NoteStatusController.to.isEditing == false && isDrawerSave == false) {
      //
      NoteStatusController.to.updateNoteMode(NoteMode.adding);
      Navigator.pop(context);
      //
    } else if (NoteStatusController.to.isEditing) {
      String _title = _titleController.text;
      String _note = _quillController.value!.document.toPlainText().trim();

      if (_title.isEmpty && _note.isEmpty) {
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
        showToast("Can't create empty note");
        NoteStatusController.to.updateIsEditing(false);
        NoteStatusController.to.updateNoteMode(NoteMode.adding);
      } else {
        FocusScope.of(context).unfocus();
        NoteStatusController.to.updateIsEditing(false);

        if (NoteStatusController.to.noteMode == NoteMode.adding) {
          _notesModel.value = NotesModel(
            title: _title.isNotEmpty ? _title : 'Untitled',
            text: _note,
            znote: jsonEncode(_quillController.value!.document.toDelta().toJson()),
            created: DateTime.now().toString(),
            modified: DateTime.now().toString(),
            tags: noteTagsList.toList(),
          );

          Get.find<NotesController>().addNewNote(_notesModel.value!);
          //
        } else if (NoteStatusController.to.noteMode == NoteMode.editing) {
          _notesModel.value = _notesModel.value!.copyWith(
            id: _notesModel.value!.id,
            title: _title.isNotEmpty ? _title : 'Untitled',
            text: _note,
            znote: jsonEncode(_quillController.value!.document.toDelta().toJson()),
            trash: _notesModel.value!.trash,
            created: _notesModel.value!.created,
            modified: DateTime.now().toString(),
            tags: noteTagsList.toList(),
          );
          Get.find<NotesController>().updateNote(_notesModel.value!);
        }

        showToast('Note saved succesfully');
      }
    }
  }

  void showToast(String msg) {
    Fluttertoast.showToast(msg: msg);
  }
}
