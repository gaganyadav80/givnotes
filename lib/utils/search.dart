import 'package:flutter/material.dart';
// import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/enums/prefs.dart';
import 'package:givnotes/packages/GFSearchBar.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/morpheus.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    if (!prefsBox.containsKey('searchList')) {
      prefsBox.put('searchList', []);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('SEARCH LIST = ${prefsBox.get('searchList')} =======================');
    return Padding(
      padding: EdgeInsets.only(top: 1.5 * hm),
      child: FutureBuilder(
        future: NotesDB.getNoteList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final notes = snapshot.data;

            return GFSearchBar(
              searchList: (prefsBox.get('searchList') as List).cast<String>(),
              searchQueryBuilder: (query, list) {
                return list.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
              },
              noItemsFoundWidget: Text(
                'Ops! nothing found',
                style: GoogleFonts.ubuntu(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
              ),
              overlaySearchListItemBuilder: (item) {
                index = (prefsBox.get('searchList') as List).cast<String>().indexOf(item);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                    Text(
                      notes[index]['title'],
                      style: GoogleFonts.ubuntu(
                        fontSize: 2.3 * hm,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5 * hm),
                    Text(
                      notes[index]['text'],
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
              onItemSelected: (item) {
                Var.noteMode = NoteMode.Editing;
                Var.note = notes[index];
                Navigator.push(
                  context,
                  MorpheusPageRoute(
                    builder: (context) => ZefyrEdit(noteMode: NoteMode.Editing),
                  ),
                );
              },
            );
          }
          return Scaffold(backgroundColor: Colors.white);
        },
      ),
    );
  }
}
