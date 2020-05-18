import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:focus_widget/focus_widget.dart';
import 'package:givnotes/pages/home.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/homePageItems.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:zefyr/zefyr.dart';
import 'package:route_transitions/route_transitions.dart' as rt;

enum NoteMode { Editing, Adding }
Future<String> get _localPath async {
  final dir = await getApplicationDocumentsDirectory();
  return dir.path;
}

class ZefyrEdit extends StatefulWidget {
  final NoteMode noteMode;
  final bool isTrash;
  final Map<String, dynamic> note;

  ZefyrEdit(this.noteMode, [this.isTrash, this.note, Key key]) : super(key: key);

  @override
  _ZefyrEditState createState() => _ZefyrEditState();
}

class _ZefyrEditState extends State<ZefyrEdit> {
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _zefyrfocusNode = FocusNode();
  final FocusNode _titleFocus = FocusNode();
  ZefyrController _zefyrController;
  File file;

  Future<NotusDocument> _loadDocument() async {
    final path = await _localPath;
    if (widget.noteMode == NoteMode.Adding) {
      file = File(path + "/temp.json");
      print('file name: ${file.path}');
      // print('note open id : ${widget.note['id']}');

    } else if (widget.noteMode == NoteMode.Editing) {
      print('note open id : ${widget.note['id']}');
      file = File(path + "/${widget.note['id']}.json");
    }

    if (await file.exists()) {
      final contents = await file.readAsString();
      print('load contents: $contents');
      return NotusDocument.fromJson(jsonDecode(contents));
    }

    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }

  void _saveDocument(BuildContext context) {
    // Notus documents can be easily serialized to JSON by passing to
    // `jsonEncode` directly
    final contents = jsonEncode(_zefyrController.document);
    // final path = _localPath;
    // final file = File("$path/${widget.note['id']}.json");
    file.writeAsString(contents).then((_) {
      // TODO: Add a message, snackbar or something
      print('file name: ${file.path}');
      // print('Plain text : ${_zefyrController.document.toPlainText()}');
      // print('To string : ${_zefyrController.document.toString()}');
      // print('jsonEncode _zefyr.document : $contents');
      // print('jsonDecode : ${jsonDecode('[{"insert":"${widget.note['text']}"}]')}');
    });
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
    if (widget?.noteMode == NoteMode.Editing) {
      _titleController.text = widget.note['title'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = (_zefyrController == null)
        ? Center(child: CircularProgressIndicator())
        : ZefyrScaffold(
            child: ZefyrEditor(
              padding: EdgeInsets.zero,
              controller: _zefyrController,
              focusNode: _zefyrfocusNode,
            ),
          );

    return Scaffold(
      drawer: DrawerItems(),
      appBar: widget.isTrash == false
          ? MyAppBar(widget.noteMode == NoteMode.Adding ? 'NEW NOTE' : 'EDIT NOTE', true)
          : MyAppBar('DELETED NOTE', true),
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        child: Column(
          children: <Widget>[
            // ! Text Fields Start
            FocusWidget(
              focusNode: _titleFocus,
              child: TextField(
                focusNode: _titleFocus,
                controller: _titleController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Untitled',
                  hintStyle: TextStyle(
                    fontSize: 25,
                  ),
                ),
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(
              thickness: 0.5,
              color: Colors.black,
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: body,
            ),
            // ! Text Field Ends

            Container(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                widget.isTrash == false
                    ? _NoteButton(
                        'Save',
                        Colors.green,
                        () async {
                          final title = _titleController.text;

                          if (widget?.noteMode == NoteMode.Adding) {
                            NotesDB.insertNote({
                              'title': title,
                              'text': _zefyrController.document.toPlainText(),
                            });

                            NotesDB.getItemRenameList({
                              'title': title,
                              'text': _zefyrController.document.toPlainText(),
                            }).then((value) async {
                              print('note insert id : ${value[0]['id']}');
                              final path = await _localPath;
                              file.rename(path + '/${value[0]['id']}.json');
                              print('file name: ${file.path}');
                            });

                            _saveDocument(context);

                            Navigator.push(
                              context,
                              rt.PageRouteTransition(
                                builder: (context) => NotesView(isTrash: false),
                                animationType: rt.AnimationType.slide_right,
                              ),
                            );
                          } else if (widget?.noteMode == NoteMode.Editing) {
                            NotesDB.updateNote({
                              'id': widget.note['id'],
                              'title': title,
                              'text': _zefyrController.document.toPlainText(),
                            });
                            _saveDocument(context);
                            Navigator.pop(context);
                          }
                        },
                      )
                    : _NoteButton(
                        'Restore',
                        Colors.green,
                        () async {
                          await NotesDB.updateNote({
                            'id': widget.note['id'],
                            'title': _titleController.text,
                            'text': _zefyrController.document.toPlainText(),
                            'trash': 0,
                          });
                          Navigator.pop(context);
                        },
                      ),
                // TODO : remove this button, useless
                SizedBox(width: 20),
                _NoteButton(
                  'Discard',
                  Colors.grey,
                  () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 20),

                if (widget.noteMode == NoteMode.Editing && widget.isTrash == false)
                  _NoteButton('Trash', Colors.orange, () async {
                    await NotesDB.updateNote({
                      'id': widget.note['id'],
                      'title': _titleController.text,
                      'text': _zefyrController.document.toPlainText(),
                      'trash': 1,
                    });
                    Navigator.pop(context);
                  }),
                if (widget.noteMode == NoteMode.Editing && widget.isTrash == true)
                  _NoteButton(
                    'Delete',
                    Colors.red,
                    () {
                      // TODO: Update the id if inbetween item is deleted
                      // ex. 1->2->3 => (and delete 2) => 1->3 => (then update) => 1->2
                      // ?? But can't update the file name if lots of entries to be updated
                      _confirmDeleteAlert(context, widget.note['id']);
                    },
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _NoteButton extends StatelessWidget {
  final String _text;
  final Color _color;
  final Function _onPressed;

  _NoteButton(this._text, this._color, [this._onPressed]);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _onPressed,
      child: Text(
        _text,
        style: TextStyle(color: Colors.white),
      ),
      color: _color,
    );
  }
}

_confirmDeleteAlert(context, int _id) {
  Alert(
    context: context,
    type: AlertType.info,
    title: "Confirm Delete?",
    desc: "Are you sure you permanently want to delete your note?",
    buttons: [
      DialogButton(
        child: Text(
          "Cancle",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Color.fromRGBO(0, 179, 134, 1.0),
      ),
      DialogButton(
        child: Text(
          "Delete",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () async {
          await NotesDB.deleteNote(_id);
          final path = await _localPath;
          final file = File(path + "/$_id.json");
          file.delete();
          Navigator.pop(context);
          Navigator.pop(context);
        },
        gradient: LinearGradient(
            colors: [Color.fromRGBO(116, 116, 191, 1.0), Color.fromRGBO(52, 138, 199, 1.0)]),
      )
    ],
  ).show();
}
