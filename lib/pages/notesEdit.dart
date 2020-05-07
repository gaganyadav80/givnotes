import 'package:flutter/material.dart';
import 'package:givnotes/utils/notesDB.dart';

import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/homePageItems.dart';

enum NoteMode { Editing, Adding }

class NotesEdit extends StatefulWidget {
  final NoteMode noteMode;
  final Map<String, dynamic> note;

  NotesEdit(this.noteMode, [this.note]);

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
        appBar: MyAppBar(widget.noteMode == NoteMode.Adding ? 'NEW NOTE' : 'EDIT NOTE', true),
        body: Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 20),
          child: Column(
            children: <Widget>[
              // ! Text Fields Start
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Untitled',
                  hintStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
                ),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // TODO : Add Markdown support
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Empty Note',
                  hintStyle: TextStyle(fontSize: 18),
                ),
                style: TextStyle(fontSize: 18),
              ),
              // ! Text Field Ends

              Container(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _NoteButton(
                    'Save',
                    Colors.green,
                    () {
                      final title = _titleController.text;
                      final text = _textController.text;

                      if (widget?.noteMode == NoteMode.Adding) {
                        NotesDB.insertNote({
                          'title': title,
                          'text' : text, 
                        });
                      } else if (widget?.noteMode == NoteMode.Editing) {
                        NotesDB.updateNote({
                          'id' : widget.note['id'],
                          'title' : title,
                          'text' : text,
                        });
                      }
                      Navigator.pop(context);
                    },
                  ),
                  _NoteButton(
                    'Discard',
                    Colors.grey,
                    () {
                      Navigator.pop(context);
                    },
                  ),
                  widget.noteMode == NoteMode.Editing
                      ? _NoteButton('Delete', Colors.red, () async {
                          await NotesDB.deleteNote(widget.note['id']);
                          Navigator.pop(context);
                        })
                      : SizedBox(),
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
