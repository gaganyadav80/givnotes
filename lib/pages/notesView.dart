import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesView extends StatefulWidget {
  final bool isTrash;
  NotesView({this.isTrash});

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // DateTime created, modified;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        // ! Chechk this
        // future: widget.isTrash == false ? NotesDB.getNoteList() : NotesDB.getTrashNoteList(),
        future: NotesDB.getNoteList(),
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
                // reverse: true,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  index = notes.length - index - 1;
                  //
                  // created = DateFormat('dd-MM-yyyy').parse(notes[index]['created']);
                  // modified = DateFormat('dd-MM-yyyy').parse(notes[index]['modified']);
                  //
                  return OpenContainer(
                    transitionDuration: Duration(milliseconds: 500),
                    transitionType: ContainerTransitionType.fade,
                    closedElevation: 0.0,
                    openElevation: 0.0,
                    closedBuilder: (context, action) {
                      return Card(
                        elevation: 0,
                        margin: EdgeInsets.symmetric(horizontal: 2.8 * wm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // MaterialButton(
                            //   color: Colors.red,
                            //   onPressed: () => uploadFileToGoogleDrive(context),
                            //   child: Text("Upload"),
                            // ),
                            Divider(
                              height: 0.03 * hm,
                              color: Colors.black,
                            ),
                            SizedBox(height: 1.5 * hm),
                            Text(
                              "created:     ${notes[index]['created']}",
                              style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                                fontSize: 1.6 * hm,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              "modified:   ${notes[index]['modified']}",
                              style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                                fontSize: 1.6 * hm,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(height: 2 * hm),
                            _NoteTitle(notes[index]['title']),
                            SizedBox(height: 0.5 * hm),
                            _NoteText(notes[index]['text']),
                            SizedBox(height: 2 * hm),
                            Divider(
                              height: 0.03 * hm,
                              color: Colors.black,
                            ),
                            SizedBox(height: 1 * hm),
                          ],
                        ),
                      );
                    },
                    openBuilder: (context, action) {
                      Var.noteMode = NoteMode.Editing;
                      Var.note = notes[index];
                      // print('isEditing: ${Var.isEditing}');

                      return ZefyrEdit(noteMode: NoteMode.Editing);
                    },
                  );
                  // return GestureDetector(
                  //   onTap: () {
                  //     Var.noteMode = NoteMode.Editing;
                  //     Var.note = notes[index];
                  //     print('isEditing: ${Var.isEditing}');

                  //     Navigator.push(
                  //       context,
                  //       PageRouteTransition(
                  //         builder: (context) => ZefyrEdit(noteMode: NoteMode.Editing),
                  //         animationType: AnimationType.fade,
                  //       ),
                  //     );
                  //   },
                  //   child: Card(
                  //     elevation: 0,
                  //     margin: EdgeInsets.symmetric(horizontal: 2.8 * wm),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: <Widget>[
                  //         MaterialButton(
                  //           color: Colors.red,
                  //           onPressed: () => uploadFileToGoogleDrive(context),
                  //           child: Text("Upload"),
                  //         ),
                  //         Divider(
                  //           height: 0.03 * hm,
                  //           color: Colors.black,
                  //         ),
                  //         SizedBox(height: 1.5 * hm),
                  //         Text(
                  //           "created:     ${notes[index]['created']}",
                  //           style: GoogleFonts.ubuntu(
                  //             fontWeight: FontWeight.w300,
                  //             color: Colors.grey,
                  //             fontSize: 1.6 * hm,
                  //             fontStyle: FontStyle.italic,
                  //           ),
                  //         ),
                  //         Text(
                  //           "modified:   ${notes[index]['modified']}",
                  //           style: GoogleFonts.ubuntu(
                  //             fontWeight: FontWeight.w300,
                  //             color: Colors.grey,
                  //             fontSize: 1.6 * hm,
                  //             fontStyle: FontStyle.italic,
                  //           ),
                  //         ),
                  //         SizedBox(height: 2 * hm),
                  //         _NoteTitle(notes[index]['title']),
                  //         SizedBox(height: 0.5 * hm),
                  //         _NoteText(notes[index]['text']),
                  //         SizedBox(height: 2 * hm),
                  //         Divider(
                  //           height: 0.03 * hm,
                  //           color: Colors.black,
                  //         ),
                  //         SizedBox(height: 1 * hm),
                  //       ],
                  //     ),
                  //   ),
                  // );
                },
              );
            }
          }
          return Scaffold(backgroundColor: Colors.white);
        },
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

// return Padding(
//   padding: EdgeInsets.only(left: 36 * wm, top: 21 * hm),
//   child: Container(
//     height: 120,
//     width: 120,
//     child: FlareActor(
//       'assets/animations/loading.flr',
//       animation: 'Alarm',
//       alignment: Alignment.center,
//     ),
//   ),
// );
