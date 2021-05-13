import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:givnotes/widgets/search_text_field.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/routes.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<NotesModel> _notes = [];
  final RxList<NotesModel> _searchList = <NotesModel>[].obs;

  @override
  void initState() {
    super.initState();

    _textController.addListener(() {
      final text = _textController.text;

      if (text.trim().isNotEmpty) {
        _searchList.clear();

        final filterList = _notes
            .where(
              (element) => (element.title + ' ' + element.text).toLowerCase().contains(text.toLowerCase()),
            )
            .toList();

        _searchList
          ..clear()
          ..addAll(filterList);
        //
      } else if (text.isEmpty && _focusNode.hasFocus) {
        _searchList.clear();
      }
    });
  }

  void onSearchListItemLongPress(NotesModel item) {
    _focusNode.unfocus();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 400.h,
          padding: EdgeInsets.symmetric(horizontal: 0.035.sw, vertical: 0.025.sh),
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

    BlocProvider.of<NoteStatusCubit>(context).updateNoteMode(NoteMode.Editing);
    Navigator.pushNamed(context, RouterName.editorRoute, arguments: [NoteMode.Editing, item]);
  }

  @override
  void dispose() {
    _textController?.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final HydratedPrefsState _prefsCubit = BlocProvider.of<HydratedPrefsCubit>(context).state;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              leading: IconButton(
                icon: Icon(CupertinoIcons.arrow_left),
                color: Colors.black,
                onPressed: () {
                  // BlocProvider.of<NoteAndSearchCubit>(context).clearSearchList();
                  Navigator.pop(context);
                },
              ),
              elevation: 0.0,
              backgroundColor: Colors.white,
              expandedHeight: 20.w,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'Search',
                  style: TextStyle(
                    height: 0.0,
                    fontSize: 22.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: searchNoteTextField(),
              titleSpacing: 10.0.w,
            ),
            ValueListenableBuilder(
                valueListenable: Hive.box<NotesModel>('givnotes').listenable(),
                builder: (context, Box<NotesModel> box, widget) {
                  _notes = box.values.toList();

                  return Obx(() => _searchList.length == 0
                      ? _textController.text.isEmpty
                          ? SliverToBoxAdapter(
                              child: Center(
                                child: SingleChildScrollView(
                                  physics: null,
                                  child: Padding(
                                    padding: EdgeInsets.all(0.05.sw),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 50.h),
                                        Image.asset(
                                          isDark ? 'assets/giv_img/search_dark.png' : 'assets/giv_img/search_light.png',
                                          height: 180.h,
                                        ),
                                        Center(
                                          child: Text(
                                            'Search for your notes',
                                            style: TextStyle(
                                              fontSize: 12.w,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.only(top: 20.h),
                                child: Text(
                                  'Ops! nothing found',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18.w,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              index = _searchList.length - index - 1;

                              final item = _searchList.elementAt(index);
                              String _created = DateFormat.yMMMd().format(item.created);

                              return Card(
                                elevation: 0,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(5),
                                  onTap: () => onSearchListItemSelected(item),
                                  onLongPress: () => onSearchListItemLongPress(item),
                                  child: _textController.text.isNotEmpty
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              index == 0 ? Divider(height: 0.0, thickness: 1.0) : SizedBox.shrink(),
                                              Row(
                                                children: [
                                                  item.tagsMap.length == 0
                                                      ? SizedBox.shrink()
                                                      : Expanded(
                                                          flex: 4,
                                                          child: Container(
                                                            margin: EdgeInsets.only(top: 5.w),
                                                            height: _prefsCubit.compactTags ? 8.h : 18.h,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                            child: ListView.builder(
                                                              scrollDirection: Axis.horizontal,
                                                              itemCount: item.tagsMap.length,
                                                              itemBuilder: (cntx, index) {
                                                                String title = item.tagsMap.keys.toList()[index];
                                                                Color color = Color(item.tagsMap[title]);

                                                                return _prefsCubit.compactTags
                                                                    ? Container(
                                                                        width: 30.w,
                                                                        margin: EdgeInsets.only(right: 5.w),
                                                                        decoration: BoxDecoration(
                                                                          color: color,
                                                                          borderRadius: BorderRadius.circular(5.r),
                                                                        ),
                                                                        child: SizedBox.shrink(),
                                                                      )
                                                                    : Container(
                                                                        height: 18.h,
                                                                        margin: EdgeInsets.only(right: 5.w),
                                                                        padding: EdgeInsets.symmetric(horizontal: 5.w),
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
                                                                              letterSpacing: 0.5.w,
                                                                              fontSize: 8.w,
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
                                                      padding: EdgeInsets.only(top: 3.h),
                                                      child: Text(
                                                        item.trash ? 'Deleted' : '',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w300,
                                                          // color: Colors.red,
                                                          fontSize: 12.w,
                                                          fontStyle: FontStyle.italic,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5.w),
                                              Text(
                                                item.title,
                                                style: TextStyle(
                                                  fontSize: 18.w,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 5.w),
                                              Text(
                                                item.text,
                                                style: TextStyle(
                                                  color: Colors.grey[800],
                                                ),
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 5.w),
                                              Text(
                                                "created  $_created",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(height: 10.0.w),
                                              Divider(height: 0.0, thickness: 1.0),
                                            ],
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ),
                              );
                            },
                            childCount: _searchList.length,
                          ),
                        ));
                }),
          ],
        ),
      ),
    );
  }

  Widget searchNoteTextField() {
    return CustomSearchTextField(
      controller: _textController,
      focusNode: _focusNode,
      useBorders: false,
      padding: const EdgeInsets.fromLTRB(8, 10, 0, 10),
      placeholder: 'Search notes',
    );
  }
}
