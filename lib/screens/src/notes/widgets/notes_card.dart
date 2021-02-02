import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/cubit/note_search_cubit/note_search_cubit.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/global/utils.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/services/services.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

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
  Map<String, int> _allTagsMap;
  Color _splashColor;

  @override
  void initState() {
    super.initState();
    _created = DateFormat.yMMMd().add_jm().format(widget.note.created);
    _allTagsMap = prefsBox.allTagsMap;
  }

  @override
  Widget build(BuildContext context) {
    // final NoteEditStore _noteEditStore = context.read(noteEditProvider);
    _splashColor = widget.note.tagsMap.length == 0 ? Colors.black : Color(widget.note.tagsMap.values.last);
    final hm = context.percentHeight;
    final wm = context.percentWidth;
    final HydratedPrefsCubit prefsCubit = BlocProvider.of<HydratedPrefsCubit>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // color: Colors.white,
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: widget.multiSelectController.isSelected(widget.index) ? Colors.grey[300] : Colors.black.withOpacity(0.7),
        margin: EdgeInsets.zero,
        child: InkWell(
          radius: 600, //maybe change to 400-500
          splashColor: _splashColor,
          borderRadius: BorderRadius.circular(8),
          //TODO flag
          // onLongPress: () {
          //   setState(() {
          //     widget.multiSelectController.toggle(widget.index);
          //   });
          //   widget.notesViewUpdate();
          // },
          onTap: () {
            if (widget.multiSelectController.isSelecting) {
              setState(() {
                widget.multiSelectController.toggle(widget.index);
                if (!widget.multiSelectController.isSelecting) {}
              });
              widget.notesViewUpdate();
              //
            } else {
              BlocProvider.of<NoteAndSearchCubit>(context).updateNoteMode(NoteMode.Editing);

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
            // padding: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(horizontal: 0.025380711 * screenSize.width),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(height: 0.057 * wm),
                // SizedBox(height: 4),
                SizedBox(height: 0.005263158 * screenSize.height),
                widget.note.tagsMap.length == 0
                    ? SizedBox(height: wm)
                    : Container(
                        margin: EdgeInsets.only(top: 1.5 * wm),
                        height: prefsCubit.state.compactTags ? 1 * hm : 2.3 * hm,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).cardColor,
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.note.tagsMap.length,
                          itemBuilder: (context, index) {
                            String tagsTitle = widget.note.tagsMap.keys.toList()[index];
                            Color color = Color(_allTagsMap[tagsTitle]);
                            // Color color = Color(widget.note.tagsMap[tagsTitle]);

                            return prefsCubit.state.compactTags
                                ? Container(
                                    width: 7.6 * wm,
                                    // margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    margin: EdgeInsets.fromLTRB(0, 0, 0.012690355 * screenSize.width, 0),
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: SizedBox.shrink(),
                                  )
                                : Container(
                                    // margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    margin: EdgeInsets.fromLTRB(0, 0, 0.012690355 * screenSize.width, 0),
                                    // padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                    padding: EdgeInsets.fromLTRB(0.012690355 * screenSize.width, 0.002631579 * screenSize.height, 0.012690355 * screenSize.width, 0.002631579 * screenSize.height),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        tagsTitle,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ),
                // SizedBox(height: wm),
                SizedBox(height: 0.005184211 * screenSize.height),
                Text(
                  widget.note.title,
                  style: TextStyle(
                    fontSize: 4.4 * wm,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // SizedBox(height: wm),
                SizedBox(height: 0.005184211 * screenSize.height),
                Text(
                  widget.note.text,
                  style: TextStyle(
                    color: Colors.grey[800],
                    // fontSize: 3 * wm,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.005184211 * screenSize.height),
                Text(
                  "created  $_created",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                    fontSize: 3 * wm,
                    // fontStyle: FontStyle.italic,
                  ),
                ),
                // SizedBox(height: 10),
                SizedBox(height: 0.013157895 * screenSize.height),
                // Divider(
                //   height: 0.057 * wm,
                //   color: Colors.black,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
