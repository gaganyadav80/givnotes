import 'package:flutter/material.dart';
import 'package:givnotes/database/HiveDB.dart';
import 'package:givnotes/packages/multi_select_item.dart';
import 'package:givnotes/pages/notesView.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotesCard extends StatefulWidget {
  NotesCard({
    Key key,
    @required this.index,
    @required this.note,
    @required this.multiSelectController,
    this.notesViewUpdate,
  }) : super(key: key);

  final int index;
  final NotesModel note;
  final MultiSelectController multiSelectController;
  final Function notesViewUpdate;

  @override
  _NotesCardState createState() => _NotesCardState();
}

class _NotesCardState extends State<NotesCard> {
  String _created;
  bool compactTags = false;

  @override
  void initState() {
    super.initState();
    _created = DateFormat.yMMMd().add_jm().format(widget.note.created);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: widget.multiSelectController.isSelected(widget.index) ? Colors.grey[300] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onLongPress: () {
          setState(() {
            widget.multiSelectController.toggle(widget.index);
            fabIcon = Var.isTrash ? Icons.restore : Icons.delete;
            fabLabel = Var.isTrash ? 'Restore' : 'Trash';
          });
          widget.notesViewUpdate();
        },
        onTap: () {
          if (widget.multiSelectController.isSelecting) {
            setState(() {
              widget.multiSelectController.toggle(widget.index);
              if (!widget.multiSelectController.isSelecting) {
                fabIcon = Icons.add;
              }
            });
            widget.notesViewUpdate();
            //
          } else {
            Var.noteMode = NoteMode.Editing;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ZefyrEdit(
                  noteMode: NoteMode.Editing,
                  note: widget.note,
                ),
              ),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.5 * wm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(
                height: 0.057 * wm,
                color: Colors.black,
              ),
              // SizedBox(height: 1.5 * wm),
              widget.note.tagsMap.length == 0
                  ? SizedBox(height: wm)
                  : Container(
                      margin: EdgeInsets.only(top: 1.5 * wm),
                      height: compactTags ? 1 * hm : 2 * hm,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.note.tagsMap.length,
                        itemBuilder: (context, index) {
                          String tagsTitle = widget.note.tagsMap.keys.toList()[index];
                          Color color = Color(widget.note.tagsMap[tagsTitle]);

                          return compactTags
                              ? Container(
                                  width: 7.6 * wm,
                                  margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: SizedBox.shrink(),
                                )
                              : Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      //TODO remove uppercase
                                      tagsTitle,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                        fontSize: 1.2 * hm,
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
              SizedBox(height: wm),
              Text(
                widget.note.title,
                style: GoogleFonts.ubuntu(
                  fontSize: 4.4 * wm,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1 * wm),
              Text(
                widget.note.text,
                style: TextStyle(
                  color: Colors.grey[800],
                  // fontSize: 3 * wm,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: wm),
              Text(
                "created  $_created",
                style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  fontSize: 3 * wm,
                  // fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 1.5 * wm),
              Divider(
                height: 0.057 * wm,
                color: Colors.black,
              ),
            ],
          ),
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
