import 'dart:convert';
import 'dart:io';

import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:focus_widget/focus_widget.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/customAppBar.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

enum NoteMode { Editing, Adding }

Future<String> get _localPath async {
  final dir = await getApplicationDocumentsDirectory();
  return dir.path;
}

class ZefyrEdit extends StatefulWidget {
  final NoteMode noteMode;
  ZefyrEdit({this.noteMode});

  @override
  _ZefyrEditState createState() => _ZefyrEditState();
}

class _ZefyrEditState extends State<ZefyrEdit> {
  final FlareControls controls = FlareControls();

  final TextEditingController _titleController = TextEditingController();
  final FocusNode _zefyrfocusNode = FocusNode();
  final FocusNode _titleFocus = FocusNode();
  ZefyrController _zefyrController;
  File file;

  Future<NotusDocument> _loadDocument() async {
    final path = await _localPath;

    if (Var.noteMode == NoteMode.Adding) {
      file = File(path + "/temp.json");
      //
    } else if (Var.noteMode == NoteMode.Editing) {
      file = File(path + "/${Var.note['id']}.json");
    }

    if (await file.exists()) {
      final contents = await file.readAsString();
      return NotusDocument.fromJson(jsonDecode(contents));
    }

    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }

  @override
  void initState() {
    super.initState();
    _loadDocument().then((document) {
      setState(() {
        _zefyrController = ZefyrController(document);
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (Var.noteMode == NoteMode.Editing) {
      _titleController.text = Var.note['title'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Widget _editorBody = (_zefyrController == null)
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          )
        : ZefyrScaffold(
            child: ZefyrTheme(
              data: ZefyrThemeData(
                toolbarTheme: ToolbarTheme(
                  color: Color(0xffE4E7E9),
                  toggleColor: Colors.grey,
                  iconColor: Colors.black,
                  disabledIconColor: Colors.grey,
                ),
              ),
              //TODO: selection not working properly
              child: ZefyrEditor(
                mode: Var.isEditing || Var.noteMode == NoteMode.Adding
                    ? ZefyrMode.edit
                    : ZefyrMode.view,
                autofocus: false,
                padding: EdgeInsets.symmetric(horizontal: 3.5 * wm),
                controller: _zefyrController,
                focusNode: _zefyrfocusNode,
              ),
            ),
          );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        extendBody: true,
        backgroundColor: Colors.white,
        appBar: MyAppBar(
          Var.isTrash ? 'DELETED NOTE' : 'NOTE',
          isNote: true,
          controls: controls,
          titleController: _titleController,
          zefyrController: _zefyrController,
          localPath: _localPath,
          file: file,
        ),
        endDrawer: EndDrawerItems(
          titleController: _titleController,
          zefyrController: _zefyrController,
          localPath: _localPath,
          controls: controls,
          file: file,
        ),

        floatingActionButton: Var.noteMode == NoteMode.Editing
            ? Padding(
                padding: EdgeInsets.only(bottom: 8 * hm),
                child: FloatingActionButton(
                  backgroundColor: Colors.black,
                  elevation: 5,
                  child: Icon(
                    Icons.edit,
                  ),
                  onPressed: () {
                    //TODO: change the zefyrMode
                    controls.play('edit');
                  },
                ),
              )
            : null,

        // body of editor
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.5 * wm),
              child: FocusWidget(
                focusNode: _titleFocus,
                child: TextField(
                  focusNode: _titleFocus,
                  controller: _titleController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Untitled',
                    hintStyle: TextStyle(
                      fontSize: 2.5 * hm,
                    ),
                  ),
                  style: GoogleFonts.ubuntu(
                    fontSize: 2.5 * hm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Divider(
              indent: 3.5 * wm,
              endIndent: 3.5 * wm,
              thickness: 0.03 * hm,
              color: Colors.black,
            ),
            SizedBox(height: 2.5 * hm),
            Expanded(
              flex: 1,
              child: _editorBody,
            ),
          ],
        ),
      ),
    );
  }
}

// return Scaffold(
//   backgroundColor: Colors.white,
//   drawer: DrawerItems(),
//   appBar: Var.isTrash == false
//       ? MyAppBar(Var.noteMode == NoteMode.Adding ? 'New Note' : 'Edit Note', true)
//       : MyAppBar('Deleted Note', true),

// final path = _localPath;
// final file = File("$path/${Var.note['id']}.json");
// print('Plain text : ${_zefyrController.document.toPlainText()}');
// print('To string : ${_zefyrController.document.toString()}');
// print('jsonEncode _zefyr.document : $contents');
// print('jsonDecode : ${jsonDecode('[{"insert":"${Var.note['text']}"}]')}');
