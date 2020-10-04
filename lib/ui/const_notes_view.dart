import 'package:flutter/material.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/packages/multi_select_item.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesCard extends StatelessWidget {
  const NotesCard({Key key, this.controller, this.index, this.notes}) : super(key: key);

  final MultiSelectController controller;
  final List notes;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: controller.isSelected(index) ? Colors.grey[300] : Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.5 * wm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(
              height: 0.057 * wm,
              color: Colors.black,
            ),
            SizedBox(height: 2.8 * wm),
            Text(
              "created:     ${notes[index]['created']}",
              style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w300,
                color: Colors.grey,
                fontSize: 3 * wm,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              "modified:   ${notes[index]['modified']}",
              style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w300,
                color: Colors.grey,
                fontSize: 3 * wm,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 3.8 * wm),
            // _NoteTitle(notes[index]['title']),
            Text(
              notes[index]['title'],
              style: GoogleFonts.ubuntu(
                fontSize: 4.4 * wm,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.95 * wm),
            // _NoteText(notes[index]['text']),
            Text(
              notes[index]['text'],
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 3 * wm,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.95 * wm),
            Divider(
              height: 0.057 * wm,
              color: Colors.black,
            ),
            // SizedBox(height: 1 * hm),
          ],
        ),
      ),
    );
  }
}

class NotesEmptyView extends StatelessWidget {
  const NotesEmptyView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Var.isTrash == true
        ? SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(
                    child: Text(
                      "You don't have any trash",
                      style: GoogleFonts.ubuntu(
                        fontWeight: FontWeight.w700,
                        fontSize: 2.0 * hm,
                      ),
                    ),
                  ),
                  SizedBox(height: 0.5 * hm),
                  Center(
                    child: Text(
                      "Create 'em, trash 'em. See them",
                      style: GoogleFonts.ubuntu(
                        fontWeight: FontWeight.w400,
                        fontSize: 1.5 * hm,
                      ),
                    ),
                  ),
                  SizedBox(height: 30 * hm),
                  Padding(
                    padding: EdgeInsets.only(bottom: hm),
                    child: Image(
                      image: AssetImage('assets/images/trash.png'),
                      height: 25 * hm,
                      width: 45 * wm,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.only(left: 11 * wm),
            child: Image.asset(
              'assets/images/lady-on-phone.png',
              width: 75 * wm,
              height: 65 * hm,
            ),
          );
  }
}
