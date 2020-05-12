import 'package:flutter/material.dart';
import 'package:givnotes/pages/notesEdit.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/homePageItems.dart';
import 'package:givnotes/utils/notesDB.dart';

// TODO: This is also used for trash so change name
class NotesView extends StatefulWidget {
  final bool isTrash;
  NotesView([this.isTrash]);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: DrawerItems(),
        // !! isTrash
        appBar: MyAppBar(widget.isTrash == false ? 'ALL NOTES' : 'TRASH'),
        body: FutureBuilder(
          // !! isTrash
          future: widget.isTrash == false ? NotesDB.getNoteList() : NotesDB.getTrashNoteList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final notes = snapshot.data;
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // !! isTrash
                      widget.isTrash == false
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotesEdit(NoteMode.Editing, notes[index]),
                              ),
                            )
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NotesEdit(NoteMode.Editing, notes[index], true),
                              ),
                            );
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
            // TODO: for in menu splash screen
            return Center(child: CircularProgressIndicator(backgroundColor: Colors.white));
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
