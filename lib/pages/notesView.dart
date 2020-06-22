import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_transitions/route_transitions.dart';

class NotesView extends StatefulWidget {
  final bool isTrash;
  NotesView({this.isTrash});

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: FutureBuilder(
          future: widget.isTrash == false ? NotesDB.getNoteList() : NotesDB.getTrashNoteList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final notes = snapshot.data;
              if (notes.length == 0) {
                return widget.isTrash == true
                    ? Stack(
                        children: [
                          Positioned(
                            top: 49 * hm,
                            left: 50 * wm,
                            child: Image(
                              image: AssetImage('assets/images/trash.png'),
                              height: 25 * hm,
                              width: 45 * wm,
                            ),
                          ),
                          Positioned(
                            top: 25 * hm,
                            left: 20 * wm,
                            child: Column(
                              children: [
                                Text(
                                  "You don't have any trash",
                                  style: GoogleFonts.ubuntu(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 2.0 * hm,
                                  ),
                                ),
                                SizedBox(height: 0.5 * hm),
                                Text(
                                  "Create 'em, trash 'em. See them",
                                  style: GoogleFonts.ubuntu(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 1.5 * hm,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.only(left: 11 * wm),
                        child: Image.asset(
                          'assets/images/lady-on-phone.png',
                          width: 75 * wm,
                          height: 65 * hm,
                        ),
                      );
              } else {
                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Var.noteMode = NoteMode.Editing;
                        Var.note = notes[index];
                        Var.isEditing = true;

                        Navigator.push(
                          context,
                          PageRouteTransition(
                            builder: (context) => ZefyrEdit(noteMode: NoteMode.Editing),
                            animationType: AnimationType.slide_up,
                          ),
                        );
                      },
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.symmetric(vertical: 0.8 * hm, horizontal: 2.8 * wm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Divider(
                              height: 0.03 * hm,
                              color: Colors.black,
                            ),
                            SizedBox(height: 1.5 * hm),
                            _NoteTitle(notes[index]['title']),
                            SizedBox(height: 0.5 * hm),
                            _NoteText(notes[index]['text']),
                            SizedBox(height: 2 * hm),
                            Divider(
                              height: 0.03 * hm,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
            return Padding(
              padding: EdgeInsets.only(left: 36 * wm, top: 21 * hm),
              child: Container(
                height: 120,
                width: 120,
                child: FlareActor(
                  'assets/animations/loading.flr',
                  animation: 'Alarm',
                  alignment: Alignment.center,
                ),
              ),
            );
          },
        ),
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
      style: GoogleFonts.ubuntu(
        fontSize: 2.3 * hm,
        fontWeight: FontWeight.w600,
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
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: 1.6 * hm,
      ),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }
}
