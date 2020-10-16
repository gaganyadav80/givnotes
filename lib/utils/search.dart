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
  String _modified;

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
    return Padding(
      padding: EdgeInsets.only(top: 1.5 * hm),
      child: ValueListenableBuilder(
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
                  _modified = DateFormat.yMMMd().format(item.modified);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Divider(
                        height: 0.03 * hm,
                        color: Colors.black,
                      ),
                      SizedBox(height: 1.5 * hm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "created:     $_created",
                            style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                              fontSize: 1.6 * hm,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            item.trash ? 'Deleted' : '',
                            style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.w300,
                              color: Colors.red,
                              fontSize: 1.6 * hm,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "modified:   $_modified",
                        style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                          fontSize: 1.6 * hm,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 2 * hm),
                      Text(
                        item.title,
                        style: GoogleFonts.ubuntu(
                          fontSize: 2.3 * hm,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5 * hm),
                      Text(
                        item.text,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 1.6 * hm,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2 * hm),
                      Divider(
                        height: 0.03 * hm,
                        color: Colors.black,
                      ),
                      SizedBox(height: 1 * hm),
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
      ),
    );
  }
}
