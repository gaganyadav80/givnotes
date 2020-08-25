import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:focus_widget/focus_widget.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/enums/prefs.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/customAppBar.dart';
import 'package:givnotes/utils/home.dart';
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
  // File file;

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

          floatingActionButton: Var.noteMode == NoteMode.Editing && Var.isEditing == false
              ? Padding(
                  padding: EdgeInsets.only(bottom: 8 * hm),
                  child: FloatingActionButton(
                    tooltip: 'Edit',
                    backgroundColor: Colors.black,
                    elevation: 5,
                    child: Icon(
                      Icons.edit,
                      size: 4 * wm,
                    ),
                    onPressed: () {
                      setState(() {
                        Var.isEditing = true;
                      });
                      controls.play('edit');
                    },
                  ),
                )
              : null,
          // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

          // body of editor
          body: Column(
            children: <Widget>[
              // SizedBox(height: hm),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.5 * wm),
                child: FocusWidget(
                  focusNode: _titleFocus,
                  child: TextField(
                    readOnly: !Var.isEditing,
                    focusNode: _titleFocus,
                    controller: _titleController,
                    enableInteractiveSelection: true,
                    enableSuggestions: true,
                    keyboardAppearance: Brightness.light,
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
      ),
    );
  }
  // End of build above

  Future<bool> _onPop() async {
    String title = _titleController.text;
    String note = _zefyrController.document.toPlainText().trim();

    if (title.isEmpty || note.isEmpty) {
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
          true;
    } else if (title.isNotEmpty || note.isNotEmpty) {
      saveNote();
      //
      //
    } else if (_titleController.text.isNotEmpty) {
      if (MediaQuery.of(context).viewInsets.bottom != 0) {
        return false;
      }
      return true;
    } else {
      Var.isEditing = false;
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
        showToast("Can't create empty note.");
        Navigator.pop(context);
        //
      } else {
        //
        controls.play('save');
        updateEditMode(false);

        if (Var.noteMode == NoteMode.Adding) {
          //
          time = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
          //
          if (title.isEmpty) title = 'Untitled';
          // ! generate unique id for noteid
          NotesDB.insertNote({
            'title': title,
            'text': _zefyrController.document.toPlainText(),
            'znote': jsonEncode(_zefyrController.document),
            'created': time,
            'modified': time,
          });

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

          showToast('Note saved');
        }
      }
      Var.isEditing = false;
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
