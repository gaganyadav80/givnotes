import 'package:flutter/material.dart';
import 'package:givnotes/pages/notesEdit.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/homePageItems.dart';
import 'package:givnotes/utils/notesDB.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: DrawerItems(),
        appBar: MyAppBar('ALL NOTES'),
        body: FutureBuilder(
          future: NotesDB.getNoteList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final notes = snapshot.data;
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotesEdit(NoteMode.Editing, notes[index])));
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _NoteTitle(notes[index]['title']),
                            Container(
                              // TODO : height = 4, remove child
                              height: 20,
                              child: Text('${notes[index]['trash']}'),
                            ),
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
