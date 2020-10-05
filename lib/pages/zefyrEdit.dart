import 'dart:convert';

import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/variables/prefs.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/customAppBar.dart';
import 'package:givnotes/pages/home.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:toast/toast.dart';
import 'package:zefyr/zefyr.dart';

enum NoteMode { Editing, Adding }

// Future<String> get _localPath async {
//   final dir = await getApplicationDocumentsDirectory();
//   return dir.path;
// }

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
  TextSelectionControls textSelectionControls;
  // File file;
  // GivnotesDatabase database;

  Future<NotusDocument> _loadDocument() async {
    // final path = (await getApplicationDocumentsDirectory()).path;

    // if (Var.noteMode == NoteMode.Adding) {
    //   file = File(path + "/notes/temp.json");
    // } else if (Var.noteMode == NoteMode.Editing) {
    //   file = File(path + "/notes/${Var.note['id']}.json");
    // }

    // if (await file.exists()) {
    //   final contents = await file.readAsString();
    //   return NotusDocument.fromJson(jsonDecode(contents));
    // }

    // final Delta delta = Delta()..insert("\n");
    // return NotusDocument.fromDelta(delta);

    if (Var.noteMode == NoteMode.Editing) {
      final contents = Var.note['znote'].toString();
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
    if (widget.noteMode == NoteMode.Adding) _titleFocus.requestFocus();
  }

  @override
  void didChangeDependencies() {
    if (Var.noteMode == NoteMode.Editing) {
      _titleController.text = Var.note['title'];
    }
    super.didChangeDependencies();
  }

  void updateEditMode(bool value) {
    setState(() {
      Var.isEditing = value;
    });
  }

  // TextSelectionControls _textSelectionControls;

  @override
  Widget build(BuildContext context) {
    // database = Provider.of<GivnotesDatabase>(context);

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
                // defaultLineTheme: LineTheme(textStyle: TextStyle()),
                toolbarTheme: ToolbarTheme(
                  color: Color(0xffE4E7E9),
                  toggleColor: Colors.grey,
                  iconColor: Colors.black,
                  disabledIconColor: Colors.grey,
                ),
              ),
              //TODO: selection not working properly
              child: ZefyrEditor(
                mode: Var.isEditing || Var.noteMode == NoteMode.Adding ? ZefyrMode.edit : ZefyrMode.view,
                autofocus: false,
                padding: EdgeInsets.symmetric(horizontal: 3.5 * wm),
                controller: _zefyrController,
                focusNode: _zefyrfocusNode,
              ),
            ),
          );

    return SafeArea(
      child: WillPopScope(
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
          //
          endDrawer: EndDrawerItems(
            titleController: _titleController,
            zefyrController: _zefyrController,
            updateZefyrEditMode: updateEditMode,
            controls: controls,
            // file: file,
          ),

          floatingActionButton: Var.noteMode == NoteMode.Editing && !Var.isEditing
              ? Container(
                  height: 14 * wm,
                  child: FloatingActionButton.extended(
                    tooltip: 'Edit',
                    backgroundColor: Colors.black,
                    elevation: 5,
                    // icon: Icon(Icons.create, size: 5 * wm),
                    icon: Icon(CupertinoIcons.pen, size: 5 * wm),
                    label: Text('  Edit'),
                    onPressed: () {
                      setState(() {
                        Var.isEditing = true;
                      });
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
                child: TextField(
                  readOnly: !Var.isEditing,
                  focusNode: _titleFocus,
                  controller: _titleController,
                  enableInteractiveSelection: true,
                  enableSuggestions: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Untitled',
                    hintStyle: TextStyle(fontSize: 3 * hm),
                  ),
                  style: GoogleFonts.ubuntu(fontSize: 3 * hm),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _zefyrfocusNode.requestFocus();
                  },
                ),
              ),
              Divider(
                indent: 3.5 * wm,
                endIndent: 3.5 * wm,
                thickness: 0.03 * hm,
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.5 * wm),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Divider(
                        endIndent: 2.5 * wm,
                        thickness: 0.03 * hm,
                        color: Colors.black,
                      ),
                    ),
                    Text('your note below'),
                  ],
                ),
              ),
              SizedBox(height: 1.5 * hm),
              Expanded(
                flex: 1,
                child: _editorBody,
              ),
            ],
          ),
        ),
      ),
    );
  }
  // End of build above

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
      //
    } else {
      updateEditMode(false);
    }
    return false;
  }

  void saveNote() {
    String time;

    if (Var.isEditing == false) {
      //
      Var.noteMode = NoteMode.Adding;
      Navigator.push(
        context,
        PageRouteTransition(
          builder: (context) => HomePage(),
          animationType: AnimationType.fade,
        ),
      );
      //
    } else if (Var.isEditing) {
      String title = _titleController.text;
      String note = _zefyrController.document.toPlainText().trim();

      if (title.isEmpty && note.isEmpty) {
        //
        FocusScope.of(context).unfocus();
        showToast("Can't create empty note");
        Navigator.pop(context);
        //
      } else {
        //
        FocusScope.of(context).unfocus();
        controls.play('save');
        updateEditMode(false);
        // Var.isEditing = false;

        if (Var.noteMode == NoteMode.Adding) {
          //
          time = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
          //
          if (title.isEmpty) title = 'Untitled';
          // TODO: generate unique id for noteid
          NotesDB.insertNote({
            'title': title,
            'text': _zefyrController.document.toPlainText(),
            'znote': jsonEncode(_zefyrController.document),
            'created': time,
            'modified': time,
          });
          // database.insertNote(NotesDBCompanion(
          //   title: title,
          //   note: _zefyrController.document.toPlainText(),
          //   znote: jsonEncode(_zefyrController.document),
          //   created: DateTime.now(),
          //   modified: DateTime.now(),
          //   trash: false,
          // ));

          showToast('Note saved');

          if (!prefsBox.containsKey('searchList')) {
            prefsBox.put('searchList', []);
          }
          final List<String> list = (prefsBox.get('searchList') as List).cast<String>();
          list.add(title + ' ' + note);
          prefsBox.put('searchList', list);
          //
        } else if (Var.noteMode == NoteMode.Editing) {
          //
          time = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
          //
          NotesDB.updateNote({
            'id': Var.note['id'],
            'title': title,
            'text': _zefyrController.document.toPlainText(),
            'znote': jsonEncode(_zefyrController.document),
            'modified': time,
          });
          // database.updateNote(NotesDBData(
          //   id: Var.note.id,
          //   title: title,
          //   note: _zefyrController.document.toPlainText(),
          //   znote: jsonEncode(_zefyrController.document),
          //   created: DateTime.now(),
          //   modified: DateTime.now(),
          //   trash: false,
          // ));

          showToast('Note saved');
        }
      }
      // Var.isEditing = false;
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
