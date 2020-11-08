import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:getwidget/getwidget.dart';
import 'package:givnotes/database/HiveDB.dart';
import 'package:givnotes/variables/homeVariables.dart';
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
  int index = 0;
  String _created;
  bool compactTags = false;
  List<NotesModel> _searchList = [];
  List<NotesModel> _notes = [];
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isSearchBoxSelected = false;

  @override
  void initState() {
    super.initState();

    _textController.addListener(() {
      final text = _textController.text;

      if (text.trim().isNotEmpty) {
        _searchList.clear();
        isSearchBoxSelected = true;

        final filterList = _notes.where((element) => (element.title + ' ' + element.text).toLowerCase().contains(text.toLowerCase())).toList();
        if (filterList == null) {
          throw Exception('List cannot be null');
        }

        setState(() {
          _searchList.addAll(filterList);
        });
      } else if (text.isEmpty && _focusNode.hasFocus) {
        isSearchBoxSelected = false;
        setState(() {
          _searchList.clear();
        });
      }
    });
  }

  void onSearchListItemSelected(NotesModel item) {
    // _focusNode.unfocus();
    // textController.clear();
    //
    SystemChannels.textInput.invokeMethod('TextInput.hide');

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
  }

  @override
  void dispose() {
    _textController?.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<NotesModel>('givnnotes').listenable(),
        builder: (context, Box<NotesModel> box, widget) {
          _notes = box.values.toList();

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3 * wm, vertical: 1.5 * hm),
                child: searchNoteTextField(),
              ),
              _searchList.length == 0
                  ? _textController.text.isEmpty
                      ? Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5 * wm, top: 5 * hm, right: 5 * wm),
                              child: Image.asset(
                                'assets/images/search.png',
                                height: 40 * hm,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 3 * hm),
                          child: Text(
                            'Ops! nothing found',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                              fontSize: 2.8 * hm,
                              color: Colors.grey,
                            ),
                          ),
                        )
                  : Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 1.5 * wm),
                        itemCount: _searchList.length,
                        itemBuilder: (context, index) {
                          index = _searchList.length - index - 1;

                          final item = _searchList.elementAt(index);
                          _created = DateFormat.yMMMd().format(item.created);

                          return Card(
                            elevation: 0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () => onSearchListItemSelected(_searchList[index]),
                              child: _textController.text.isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 1.5 * wm),
                                      child: Column(
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
                                          SizedBox(height: wm),
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
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          );
        });
  }

  Widget searchNoteTextField() {
    return TextField(
      controller: _textController,
      focusNode: _focusNode,
      cursorColor: Colors.black,
      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
      onEditingComplete: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        suffixIcon: isSearchBoxSelected
            ? InkWell(
                child: Icon(Icons.close, size: 22, color: Colors.black),
                onTap: () {
                  _focusNode.unfocus();
                  _textController.clear();
                  setState(() {
                    isSearchBoxSelected = false;
                  });
                },
              )
            : Icon(Icons.search, color: Colors.black),
        border: InputBorder.none,
        hintText: 'Search your ass off',
        hintStyle: TextStyle(
          fontFamily: 'Helvetica',
          fontWeight: FontWeight.w300,
          color: Colors.grey,
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
        contentPadding: const EdgeInsets.only(
          left: 16,
          right: 20,
          top: 14,
          bottom: 14,
        ),
      ),
    );
  }
}

// GFSearchBar(
//               searchList: notes,
//               controller: _searchController,
//               searchQueryBuilder: (query, List<NotesModel> list) {
//                 // return list.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
//                 return list.where((element) => (element.title + ' ' + element.text).toLowerCase().contains(query.toLowerCase())).toList();
//               },
//               noItemsFoundWidget: Text(
//                 'Ops! nothing found',
//                 style: TextStyle(
//                   fontStyle: FontStyle.italic,
//                   fontWeight: FontWeight.w400,
//                   fontSize: 2.8 * hm,
//                   color: Colors.grey,
//                 ),
//               ),
//               overlaySearchListItemBuilder: (NotesModel item) {
//                 // index = (prefsBox.get('searchList') as List).cast<String>().indexOf(item);
//                 _created = DateFormat.yMMMd().format(item.created);
//                 // _modified = DateFormat.yMMMd().format(item.modified);

//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Divider(
//                       height: 0.057 * wm,
//                       color: Colors.black,
//                     ),
//                     // SizedBox(height: 1.5 * wm),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         item.tags.length == 0
//                             ? SizedBox.shrink()
//                             : Expanded(
//                                 flex: 4,
//                                 child: Container(
//                                   margin: EdgeInsets.only(top: 1.5 * wm),
//                                   height: compactTags ? 1 * hm : 2 * hm,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//                                   child: ListView.builder(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: item.tags.length,
//                                     itemBuilder: (context, index) {
//                                       String title = item.tags[index];
//                                       Color color = Color(item.tagColor[index]);

//                                       return compactTags
//                                           ? Container(
//                                               width: 7.6 * wm,
//                                               margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
//                                               decoration: BoxDecoration(
//                                                 color: color,
//                                                 borderRadius: BorderRadius.circular(5),
//                                               ),
//                                               child: SizedBox.shrink(),
//                                             )
//                                           : Container(
//                                               margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
//                                               padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
//                                               decoration: BoxDecoration(
//                                                 color: color,
//                                                 borderRadius: BorderRadius.circular(5),
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   //TODO remove
//                                                   title.toUpperCase(),
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontWeight: FontWeight.w700,
//                                                     letterSpacing: 0.5,
//                                                     fontSize: 1.2 * hm,
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                     },
//                                   ),
//                                 ),
//                               ),
//                         Expanded(
//                           flex: 1,
//                           child: Padding(
//                             padding: EdgeInsets.only(top: 3),
//                             child: Text(
//                               item.trash ? 'Deleted' : '',
//                               style: GoogleFonts.ubuntu(
//                                 fontWeight: FontWeight.w300,
//                                 color: Colors.red,
//                                 fontSize: 1.6 * hm,
//                                 fontStyle: FontStyle.italic,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 2 * wm),
//                     Text(
//                       item.title,
//                       style: GoogleFonts.ubuntu(
//                         fontSize: 4.4 * wm,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(height: 1 * wm),
//                     Text(
//                       item.text,
//                       style: TextStyle(
//                         color: Colors.grey[800],
//                         // fontSize: 3 * wm,
//                       ),
//                       maxLines: 5,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: wm),
//                     Text(
//                       "created  $_created",
//                       style: GoogleFonts.ubuntu(
//                         fontWeight: FontWeight.w300,
//                         color: Colors.grey,
//                         fontSize: 3 * wm,
//                         // fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                     SizedBox(height: 1.5 * wm),
//                     Divider(
//                       height: 0.057 * wm,
//                       color: Colors.black,
//                     ),
//                   ],
//                 );
//               },
//               onItemSelected: (NotesModel item) {
//                 Var.noteMode = NoteMode.Editing;
//                 Navigator.push(
//                   context,
//                   MorpheusPageRoute(
//                     builder: (context) => ZefyrEdit(
//                       noteMode: NoteMode.Editing,
//                       note: item,
//                     ),
//                   ),
//                 );
//               },
//             ),
//             // SizedBox(height: 8 * hm),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.only(left: 5 * wm, top: 5 * hm, right: 5 * wm),
//                   child: Image.asset(
//                     'assets/images/profile-2.png',
//                     height: 40 * hm,
//                     // color: Colors.transparent,
//                   ),
//                 ),
//               ),
//             ),
