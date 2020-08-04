import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/search_bar/gf_search_bar.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:route_transitions/route_transitions.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> searchItems = List<String>();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: FutureBuilder(
          future: NotesDB.getNoteList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final notes = snapshot.data;

              for (int i = 0; i < notes.length; i++) {
                searchItems.add(notes[i]['title'] + " " + notes[i]['text']);
              }
              return GFSearchBar(
                searchList: searchItems,
                hideSearchBoxWhenItemSelected: true,
                searchQueryBuilder: (query, list) {
                  return list
                      .where((item) => item.toLowerCase().contains(query.toLowerCase()))
                      .toList();
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
                  index = searchItems.indexOf(item);

                  return Card(
                    elevation: 0,
                    margin: EdgeInsets.symmetric(horizontal: 2.8 * wm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider(
                          height: 0.03 * hm,
                          color: Colors.black,
                        ),
                        SizedBox(height: 1.5 * hm),
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
                      ],
                    ),
                  );
                },
                onItemSelected: (item) {
                  setState(() {
                    print('$item');
                  });
                },
              );
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
