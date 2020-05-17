import 'package:flutter/material.dart';
import 'package:focus_widget/focus_widget.dart';
import 'package:givnotes/pages/home.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/homePageItems.dart';
import 'package:route_transitions/route_transitions.dart' as rt;

enum NoteMode { Editing, Adding }
final FocusNode _titleFocus = FocusNode(), _textFocus = FocusNode();

class NotesEdit extends StatefulWidget {
  final NoteMode noteMode;
  final Map<String, dynamic> note;
  final bool isTrash;

  NotesEdit(this.noteMode, [this.isTrash, this.note]);

  @override
  _NotesEditState createState() => _NotesEditState();
}

class _NotesEditState extends State<NotesEdit> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  // List<Map<String, String>> get _notes => NoteInherited.of(context).notes;

  @override
  void didChangeDependencies() {
    if (widget?.noteMode == NoteMode.Editing) {
      _titleController.text = widget.note['title'];
      _textController.text = widget.note['text'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: DrawerItems(),
        // !! isTrash
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
              // TODO : Add Markdown support !! use zyfre
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: FocusWidget(
                    focusNode: _textFocus,
                    child: TextField(
                      focusNode: _textFocus,
                      controller: _textController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Empty Note',
                        hintStyle: TextStyle(fontSize: 20),
                      ),
                      maxLines: null,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              // ! Text Field Ends

              Container(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // !! isTrash
                  widget.isTrash == false
                      ? _NoteButton(
                          'Save',
                          Colors.green,
                          () {
                            final title = _titleController.text;
                            final text = _textController.text;

                            if (widget?.noteMode == NoteMode.Adding) {
                              NotesDB.insertNote({
                                'title': title,
                                'text': text,
                              });

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
                                'text': text,
                              });

                              Navigator.pop(context);
                            }
                          },
                        )
                      : _NoteButton(
                          'Restore',
                          Colors.green,
                          () async {
                            await NotesDB.trashNote({
                              'id': widget.note['id'],
                              'title': _titleController.text,
                              'text': _textController.text,
                              'trash': 0,
                            });
                            Navigator.pop(context);
                          },
                        ),
                  // TODO : remove this button, useless
                  _NoteButton(
                    'Discard',
                    Colors.grey,
                    () {
                      Navigator.pop(context);
                    },
                  ),
                  // TODO: correct this for adding new note
                  if (widget.noteMode == NoteMode.Editing && widget.isTrash == false)
                    _NoteButton('Trash', Colors.orange, () async {
                      await NotesDB.trashNote({
                        'id': widget.note['id'],
                        'title': _titleController.text,
                        'text': _textController.text,
                        'trash': 1,
                      });
                      Navigator.pop(context);
                    }),
                  if (widget.noteMode == NoteMode.Editing && widget.isTrash == true)
                    _NoteButton(
                      'Delete',
                      Colors.red,
                      () {
                        print('Delete pressed');
                        _confirmDeleteAlert(context, widget.note['id']);
                      },
                    ),
                ],
              )
            ],
          ),
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
    title: "Confirm Delete>",
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
        // TODO: check if this updates the list
        onPressed: () async {
          await NotesDB.deleteNote(_id);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        gradient: LinearGradient(
            colors: [Color.fromRGBO(116, 116, 191, 1.0), Color.fromRGBO(52, 138, 199, 1.0)]),
      )
    ],
  ).show();
}
