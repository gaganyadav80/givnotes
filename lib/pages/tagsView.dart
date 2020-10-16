import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:givnotes/database/HiveDB.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/variables/prefs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class TagsView extends StatefulWidget {
  @override
  _TagsViewState createState() => _TagsViewState();
}

class _TagsViewState extends State<TagsView> {
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  List<NotesModel> _notes = List<NotesModel>();
  String _created;
  String _modified;

  List<String> lst = [];
  List<String> _allTags = [];
  List<int> _allTagColors = [];
  bool editTags = false;

  @override
  void initState() {
    super.initState();
    _allTags = (prefsBox.get('allTags') as List).cast<String>();
    _allTagColors = (prefsBox.get('tagColors') as List).cast<int>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 1.5 * hm, 15, 0),
                child: Column(
                  children: [
                    Tags(
                      key: _tagStateKey,
                      itemCount: _allTags.length,
                      itemBuilder: (int index) {
                        final noteTag = _allTags[index];

                        return ItemTags(
                          key: Key(index.toString()),
                          elevation: 2,
                          index: index,
                          title: noteTag,
                          active: false,
                          textStyle: TextStyle(fontSize: 2.1 * hm),
                          combine: ItemTagsCombine.withTextBefore,
                          border: Border.all(color: Color(_allTagColors[index]), width: 1),
                          activeColor: Color(_allTagColors[index]),
                          textColor: Color(_allTagColors[index]),
                          removeButton: ItemTagsRemoveButton(
                            backgroundColor: Color(_allTagColors[index]),
                            onRemoved: () {
                              showToast("Long press to delete Tag");
                              return true;
                            },
                          ),
                          onPressed: (item) {
                            setState(() {});
                          },
                          onLongPressed: (item) {
                            // setState(() {
                            // _items.removeAt(index);
                            // });
                            showToast("Not Available yet.");
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            /*
              Build Notes
             */
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.fromLTRB(1.5 * wm, 3 * hm, 1.5 * wm, 0),
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<NotesModel>('givnnotes').listenable(),
                  builder: (context, Box<NotesModel> box, widget) {
                    lst.clear();

                    _tagStateKey.currentState.getAllItem.where((a) => a.active == true).forEach((a) => lst.add(a.title));
                    _notes = box.values.where((element) {
                      return (element.trash == Var.isTrash) &&
                          lst.any((title) {
                            return element.tags.contains(title);
                          });
                    }).toList();

                    if (_notes.length == 0) {
                      return Scaffold(
                        backgroundColor: Colors.white,
                        body: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Image.asset('assets/images/search-1.png'),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        index = _notes.length - index - 1;

                        var note = _notes[index];

                        _created = DateFormat.yMMMd().format(note.created);
                        _modified = DateFormat.yMMMd().format(note.modified);

                        return InkWell(
                          onTap: () {
                            Var.noteMode = NoteMode.Editing;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ZefyrEdit(
                                  noteMode: NoteMode.Editing,
                                  note: note,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 0,
                            color: Colors.white,
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
                                    "created:     $_created",
                                    style: GoogleFonts.ubuntu(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey,
                                      fontSize: 3 * wm,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Text(
                                    "modified:   $_modified",
                                    style: GoogleFonts.ubuntu(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey,
                                      fontSize: 3 * wm,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  SizedBox(height: 3.8 * wm),
                                  Text(
                                    note.title,
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 4.4 * wm,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 0.95 * wm),
                                  Text(
                                    note.text,
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
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showToast(String msg) {
    Toast.show(
      msg,
      context,
      duration: 3,
      gravity: Toast.BOTTOM,
      backgroundColor: toastGrey,
      backgroundRadius: 5,
    );
  }
}
