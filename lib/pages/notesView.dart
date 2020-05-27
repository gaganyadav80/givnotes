import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/utils/home.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:route_transitions/route_transitions.dart' as rt;

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
    // return Scaffold(
    // backgroundColor: Colors.white,
    // extendBodyBehindAppBar: true,
    // extendBody: true,
    // drawer: DrawerItems(),
    // !! isTrash
    // appBar: MyAppBar(widget.isTrash == false ? 'ALL NOTES' : 'TRASH'),
    return FutureBuilder(
      // !! isTrash
      future: widget.isTrash == false ? NotesDB.getNoteList() : NotesDB.getTrashNoteList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final notes = snapshot.data;
          return notes.length == 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: widget.isTrash
                      ? Column(
                          children: <Widget>[
                            SizedBox(
                              width: double.infinity,
                              height: 30,
                            ),
                            Image.asset(
                              'assets/images/trash.png',
                              width: 350,
                              height: 400,
                            ),
                            Text(
                              'Looks like you\'re empty. Ugh?',
                              style: GoogleFonts.montserrat(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        )
                      : Lottie.asset(
                          'assets/animations/1.json',
                          width: double.infinity,
                          height: 550,
                        ),
                )
              : ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          Var.noteMode = NoteMode.Editing;
                          Var.note = notes[index];
                          Var.selectedIndex = 2;
                        });
                        Navigator.push(
                          context,
                          rt.PageRouteTransition(
                            builder: (context) => HomePage(),
                            animationType: rt.AnimationType.fade,
                          ),
                        );
                        // Navigator.push(
                        //   context,
                        //   PageRouteTransition(
                        //     builder: (context) =>
                        //         ZefyrEdit(NoteMode.Editing, widget.isTrash, notes[index]),
                        //     // NotesEdit(NoteMode.Editing, false, notes[index]),
                        //     animationType: AnimationType.fade,
                        //   ),
                        // ).then((value) => setState(() => count++));
                      },
                      child: Card(
                        elevation: 3,
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
        // return Center(child: CircularProgressIndicator(backgroundColor: Colors.white));
        return SpinKitChasingDots(
          color: Colors.deepOrangeAccent[400],
        );
      },
    );
    // floatingActionButton: ActionBarMenu(),
    // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    // bottomNavigationBar: BottomMenu(),
    // );
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
        fontWeight: FontWeight.w700,
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
