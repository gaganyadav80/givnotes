import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/homePageItems.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Trash extends StatefulWidget {
  @override
  _TrashState createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: DrawerItems(),
        appBar: MyAppBar('TRASH'),
        body: FutureBuilder(
          future: NotesDB.getTrashNoteList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final notes = snapshot.data;
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TrashNotesEdit(notes[index])));
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _NoteTitle(notes[index]['title']),
                            Container(height: 4),
                            _NoteText(notes[index]['text']),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator(backgroundColor: Colors.black));
          },
        ),
        floatingActionButton: ActionBarMenu(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomMenu(),
      ),
    );
  }
}

class _NoteTitle extends StatelessWidget {
  final String _title;
  _NoteTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _NoteText extends StatelessWidget {
  final String _text;
  _NoteText(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(color: Colors.grey[800]),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

// *** Trash Notes Edit View

class TrashNotesEdit extends StatefulWidget {
  final Map<String, dynamic> note;

  TrashNotesEdit([this.note]);

  @override
  _TrashNotesEditState createState() => _TrashNotesEditState();
}

class _TrashNotesEditState extends State<TrashNotesEdit> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  @override
  void didChangeDependencies() {
    _titleController.text = widget.note['title'];
    _textController.text = widget.note['text'];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: DrawerItems(),
        appBar: MyAppBar('DELETED NOTE', true),
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
                    'RESTORE',
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
                  _NoteButton(
                    'DELETE',
                    Colors.grey,
                    () {
                      // confirmDelete(context, widget.note['id']);
                      _signOutAlert(context, widget.note['id']);
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

// TODO: check why this does not work
Widget confirmDelete(BuildContext context, int _id) {
  return GFFloatingWidget(
    child: GFAlert(
      title: 'Confirm Delete?',
      content: 'Are you sure you permanently want to delete your note?',
      type: GFAlertType.rounded,
      bottombar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          MaterialButton(
            color: Colors.red,
            child: Text(
              'CANCLE',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(width: 10),
          MaterialButton(
            color: Colors.red,
            child: Text(
              'DELETE',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await NotesDB.deleteNote(_id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}

_signOutAlert(context, int _id) {
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
