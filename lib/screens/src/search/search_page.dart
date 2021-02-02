import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/cubit/note_search_cubit/note_search_cubit.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/global/utils.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/screens/themes/app_themes.dart';
import 'package:givnotes/services/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:morpheus/morpheus.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SearchPage());
  }

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<NotesModel> _notes = [];
  Map<String, int> _allTagsMap;

  // var hm = 7.6;
  // var wm = 3.94;

  @override
  void initState() {
    super.initState();
    final NoteAndSearchCubit _tagSearchStore = BlocProvider.of<NoteAndSearchCubit>(context);
    _allTagsMap = prefsBox.allTagsMap;

    _textController.addListener(() {
      final text = _textController.text;

      if (text.trim().isNotEmpty) {
        _tagSearchStore.clearSearchList();
        // _tagSearchStore.updateBoxSelected(true);

        final filterList = _notes
            .where(
              (element) => (element.title + ' ' + element.text).toLowerCase().contains(text.toLowerCase()),
            )
            .toList();
        if (filterList == null) {
          throw Exception('List cannot be null');
        }

        _tagSearchStore.updateSearchList(filterList);
        //
      } else if (text.isEmpty && _focusNode.hasFocus) {
        // _tagSearchStore.updateBoxSelected(false);
        _tagSearchStore.clearSearchList();
      }
    });
  }

  void onSearchListItemLongPress(NotesModel item, {@required Size size}) {
    _focusNode.unfocus();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          // height: 55 * hm,
          height: 0.55 * size.height,
          // padding:
          //     EdgeInsets.symmetric(horizontal: 3.5 * wm, vertical: 2.5 * hm),
          padding: EdgeInsets.symmetric(horizontal: 0.035 * size.width, vertical: 0.025 * size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
    );
  }

  void onSearchListItemSelected(NotesModel item) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    BlocProvider.of<NoteAndSearchCubit>(context).updateNoteMode(NoteMode.Editing);
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
    // hm = context.percentHeight;
    // wm = context.percentWidth;
    // Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: GiveStatusBarColor(context),
      ),
    );
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<NoteAndSearchCubit>(context).clearSearchList();
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                leading: IconButton(
                  icon: Icon(CupertinoIcons.arrow_left),
                  color: Theme.of(context).iconTheme.color,
                  onPressed: () {
                    BlocProvider.of<NoteAndSearchCubit>(context).clearSearchList();
                    Navigator.pop(context);
                  },
                ),
                elevation: 0.0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 0.121052632 * screenSize.height,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'Search',
                    style: TextStyle(
                      height: 0.0,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                ),
              ),
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                elevation: 0.0,
                backgroundColor: Theme.of(context).textTheme.bodyText1.color,
                title: searchNoteTextField(),
                titleSpacing: 10.0,
              ),
              ValueListenableBuilder(
                  valueListenable: Hive.box<NotesModel>('givnotes').listenable(),
                  builder: (context, Box<NotesModel> box, widget) {
                    _notes = box.values.toList();

                    return BlocBuilder<NoteAndSearchCubit, NoteAndSearchState>(
                      builder: (context, state) {
                        int searchLength = state.searchList.length;

                        // print(searchLength);
                        // print(_textController.text.isEmpty);
                        return searchLength == 0
                            ? _textController.text.isEmpty
                                ? SliverToBoxAdapter(
                                    child: Center(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 0.05 * screenSize.width,
                                            top: 0.05 * screenSize.height,
                                            right: 0.05 * screenSize.width,
                                          ),
                                          // child: Image.asset(
                                          //   'assets/img/search.png',
                                          //   // height: 40 * hm,
                                          //   height: 0.4 * screenSize.height,
                                          // ),
                                          child: Center(
                                            child: Text('Search for your notes according to Tags'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : SliverToBoxAdapter(
                                    child: Padding(
                                      // padding: EdgeInsets.only(top: 3 * hm),
                                      padding: EdgeInsets.only(top: 0.03 * screenSize.height),
                                      child: Text(
                                        'Ops! nothing found',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 22,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  )
                            : AnimationLimiter(
                                child: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      int _animateIndex = index;
                                      index = searchLength - index - 1;

                                      final item = state.searchList.elementAt(index);
                                      String _created = DateFormat.yMMMd().format(item.created);

                                      return AnimationConfiguration.staggeredList(
                                        position: _animateIndex,
                                        duration: const Duration(milliseconds: 375),
                                        child: SlideAnimation(
                                          verticalOffset: 25.0,
                                          child: FadeInAnimation(
                                            child: Card(
                                              elevation: 0,
                                              child: InkWell(
                                                borderRadius: BorderRadius.circular(5),
                                                onTap: () => onSearchListItemSelected(item),
                                                onLongPress: () => onSearchListItemLongPress(item, size: screenSize),
                                                child: _textController.text.isNotEmpty
                                                    ? Padding(
                                                        padding: EdgeInsets.symmetric(
                                                          // horizontal: 1.5 * wm,
                                                          horizontal: 0.015 * screenSize.width,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Divider(
                                                              height:
                                                                  // 0.057 * wm,
                                                                  0.00057 * screenSize.height,
                                                              color: Colors.black,
                                                            ),
                                                            Row(
                                                              children: [
                                                                item.tagsMap.length == 0
                                                                    ? SizedBox.shrink()
                                                                    : Expanded(
                                                                        flex: 4,
                                                                        child: Container(
                                                                          margin:
                                                                              // EdgeInsets.only(top: 1.5 * wm),
                                                                              EdgeInsets.only(top: 0.015 * screenSize.width),
                                                                          // height: BlocProvider.of<HydratedPrefsCubit>(context).state.compactTags
                                                                          //     ? 1 * hm
                                                                          //     : 2 * hm,
                                                                          height: BlocProvider.of<HydratedPrefsCubit>(context).state.compactTags ? 0.01 * screenSize.height : 0.02 * screenSize.height,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(5),
                                                                          ),
                                                                          child: ListView.builder(
                                                                            scrollDirection: Axis.horizontal,
                                                                            itemCount: item.tagsMap.length,
                                                                            itemBuilder: (cntx, index) {
                                                                              String title = item.tagsMap.keys.toList()[index];
                                                                              Color color = Color(_allTagsMap[title]);

                                                                              return BlocProvider.of<HydratedPrefsCubit>(context).state.compactTags
                                                                                  ? Container(
                                                                                      // width: 7.6 * wm,
                                                                                      width: 0.076 * screenSize.width,
                                                                                      // margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                                                                      margin: EdgeInsets.fromLTRB(
                                                                                        0,
                                                                                        0,
                                                                                        0.0126903553 * screenSize.width,
                                                                                        0,
                                                                                      ),
                                                                                      decoration: BoxDecoration(
                                                                                        color: color,
                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                      ),
                                                                                      child: SizedBox.shrink(),
                                                                                    )
                                                                                  : Container(
                                                                                      // margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                                                                      margin: EdgeInsets.fromLTRB(
                                                                                        0,
                                                                                        0,
                                                                                        0.0126903553 * screenSize.width,
                                                                                        0,
                                                                                      ),
                                                                                      // padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                                                                      padding: EdgeInsets.fromLTRB(
                                                                                        0.0126903553 * screenSize.width,
                                                                                        0.00263157895 * screenSize.height,
                                                                                        0.0126903553 * screenSize.width,
                                                                                        0.00263157895 * screenSize.height,
                                                                                      ),
                                                                                      decoration: BoxDecoration(
                                                                                        color: color,
                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          title,
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
                                                                      ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Padding(
                                                                    // padding: EdgeInsets
                                                                    //     .only(
                                                                    //         top:
                                                                    //             3),
                                                                    padding: EdgeInsets.only(
                                                                      top: 0.00394736842 * screenSize.height,
                                                                    ),
                                                                    child: Text(
                                                                      item.trash ? 'Deleted' : '',
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.w300,
                                                                        // color: Colors.red,
                                                                        fontSize: 12,
                                                                        fontStyle: FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            // SizedBox(
                                                            //     height: wm),
                                                            SizedBox(height: 0.00518421053 * screenSize.height),
                                                            Text(
                                                              item.title,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                            SizedBox(height: 0.00518421053 * screenSize.height),
                                                            Text(
                                                              item.text,
                                                              style: TextStyle(
                                                                color: Colors.grey[800],
                                                              ),
                                                              maxLines: 5,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                            SizedBox(height: 0.00518421053 * screenSize.height),
                                                            Text(
                                                              "created  $_created",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w300,
                                                                color: Colors.grey,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            // SizedBox(
                                                            //     height:
                                                            //         1.5 * wm),
                                                            SizedBox(height: 0.00777631579 * screenSize.height),
                                                            Divider(
                                                              // height:
                                                              //     0.057 * wm,
                                                              height: 0.0002955 * screenSize.height,
                                                              color: Colors.black,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox.shrink(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    // padding: EdgeInsets.symmetric(horizontal: 1.5 * wm),
                                    childCount: searchLength,
                                  ),
                                ),
                              );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchNoteTextField() {
    return BlocBuilder<NoteAndSearchCubit, NoteAndSearchState>(
      builder: (context, state) => Container(
        // color: Theme.of(context).scaffoldBackgroundColor,
        height: 0.0492105263 * screenSize.height,
        child: CupertinoTextField(
          controller: _textController,
          focusNode: _focusNode,
          cursorColor: Colors.black,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
          onEditingComplete: () {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          },
          clearButtonMode: OverlayVisibilityMode.editing,
          placeholder: ' \u{1F50D}  Search for notes',
          // padding: EdgeInsets.only(left: 10.0),
          padding: EdgeInsets.only(left: 0.0253807107 * screenSize.width),
          toolbarOptions: ToolbarOptions(copy: true, cut: true, paste: true, selectAll: true),
          decoration: BoxDecoration(
            color: CupertinoDynamicColor.withBrightness(
              color: Theme.of(context).scaffoldBackgroundColor,
              darkColor: CupertinoColors.black,
            ),
            // border: _kDefaultRoundedBorder,
            // borderRadius: BorderRadius.all(Radius.circular(5.0)),
            // border: Border.all(
            //   color: CupertinoDynamicColor.withBrightness(
            //     // color: Color(0x33000000),
            //     // darkColor: Color(0x33FFFFFF),
            //     darkColor: Theme.of(context).scaffoldBackgroundColor,
            //     color: Colors.black,
            //   ),
            //   style: BorderStyle.solid,
            //   width: 1.0, // default 0 for cupertino
            // ),
          ),
          // decoration: InputDecoration(
          //   fillColor: Colors.white,
          //   enabledBorder: const OutlineInputBorder(
          //     borderSide: BorderSide(
          //       color: Colors.black,
          //     ),
          //   ),
          //   focusedBorder: OutlineInputBorder(
          //     borderSide: BorderSide(
          //       color: Colors.black,
          //     ),
          //   ),
          //   suffixIcon: state.isSearchBoxSelected
          //       ? InkWell(
          //           child: Icon(Icons.close, size: 22, color: Colors.black),
          //           onTap: () {
          //             _focusNode.unfocus();
          //             _textController.clear();
          //             BlocProvider.of<NoteAndSearchCubit>(context).updateBoxSelected(false);
          //           },
          //         )
          //       : Icon(Icons.search, color: Colors.black),
          //   border: InputBorder.none,
          //   hintText: 'Search for notes',
          //   hintStyle: TextStyle(
          //     fontWeight: FontWeight.w300,
          //     color: Colors.grey,
          //     fontSize: 14,
          //     fontStyle: FontStyle.italic,
          //   ),
          //   contentPadding: const EdgeInsets.only(
          //     left: 16,
          //     right: 20,
          //     top: 14,
          //     bottom: 14,
          //   ),
          // ),
        ),
      ),
    );
  }
}
