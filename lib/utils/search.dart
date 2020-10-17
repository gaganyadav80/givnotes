import 'package:flutter/material.dart';
import 'package:givnotes/database/HiveDB.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/variables/prefs.dart';
import 'package:givnotes/packages/GFSearchBar.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:morpheus/morpheus.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  int index = 0;
  String _created;
  // String _modified;
  bool compactTags = false;

  @override
  void initState() {
    super.initState();
    if (!prefsBox.containsKey('searchList')) {
      prefsBox.put('searchList', []);
    }
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<NotesModel>('givnnotes').listenable(),
      builder: (context, Box<NotesModel> box, widget) {
        final notes = box.values.toList();

        return Column(
          children: [
            GFSearchBar(
              searchList: notes,
              controller: _searchController,
              searchQueryBuilder: (query, List<NotesModel> list) {
                // return list.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
                return list.where((element) => (element.title + ' ' + element.text).toLowerCase().contains(query.toLowerCase())).toList();
              },
              noItemsFoundWidget: Text(
                'Ops! nothing found',
                style: GoogleFonts.ubuntu(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
              ),
              overlaySearchListItemBuilder: (NotesModel item) {
                // index = (prefsBox.get('searchList') as List).cast<String>().indexOf(item);
                _created = DateFormat.yMMMd().format(item.created);
                // _modified = DateFormat.yMMMd().format(item.modified);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(
                      height: 0.057 * wm,
                      color: Colors.black,
                    ),
                    // SizedBox(height: 1.5 * wm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        item.tags.length == 0
                            ? SizedBox.shrink()
                            : Expanded(
                                flex: 4,
                                child: Container(
                                  margin: EdgeInsets.only(top: 1.5 * wm),
                                  height: compactTags ? 1 * hm : 2 * hm,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: item.tags.length,
                                    itemBuilder: (context, index) {
                                      String title = item.tags[index];
                                      Color color = Color(item.tagColor[index]);

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
                                                  //TODO remove
                                                  title.toUpperCase(),
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
                              ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Text(
                              item.trash ? 'Deleted' : '',
                              style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.w300,
                                color: Colors.red,
                                fontSize: 1.6 * hm,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2 * wm),
                    Text(
                      item.title,
                      style: GoogleFonts.ubuntu(
                        fontSize: 4.4 * wm,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1 * wm),
                    Text(
                      item.text,
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
                );
              },
              onItemSelected: (NotesModel item) {
                Var.noteMode = NoteMode.Editing;
                Navigator.push(
                  context,
                  MorpheusPageRoute(
                    builder: (context) => ZefyrEdit(
                      noteMode: NoteMode.Editing,
                      note: item,
                    ),
                  ),
                );
              },
            ),
            // SizedBox(height: 8 * hm),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 5 * wm, top: 5 * hm, right: 5 * wm),
                  child: Image.asset(
                    'assets/images/profile-2.png',
                    height: 40 * hm,
                    // color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
