import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: 'Search'.text.xl2.black.medium.make(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            searchNoteTextField().pSymmetric(h: 15.w),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: Hive.box<NotesModel>('givnotes').listenable(),
                  builder: (context, Box<NotesModel> box, widget) {
                    _notes = box.values.where((element) => element.trash == false).toList();

                    return Obx(() => _searchList.length == 0
                        ? _textController.text.isEmpty
                            ? SingleChildScrollView(
                                physics: NeverScrollableScrollPhysics(),
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
                              )
                            : Padding(
                                padding: EdgeInsets.only(top: 20.h),
                                child: 'Ops! nothing found'.text.center.italic.light.lg.gray400.make(),
                              )
                        : ListView.builder(
                            itemCount: _searchList.length,
                            itemBuilder: (context, index) {
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
                                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(height: 5.0.w),
                                              item.tagsNameList.length == 0
                                                  ? SizedBox.shrink()
                                                  : Container(
                                                      margin: EdgeInsets.only(top: 6.w),
                                                      color: Colors.transparent,
                                                      height: _prefsCubit.compactTags ? 8.h : 18.h,
                                                      child: ListView.builder(
                                                        scrollDirection: Axis.horizontal,
                                                        itemCount: item.tagsNameList.length,
                                                        itemBuilder: (cntx, index) {
                                                          String title = item.tagsNameList[index];
                                                          Color color = Color(prefsBox.allTagsMap[title]);

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
                                                                    borderRadius: BorderRadius.circular(5.r),
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
                                              SizedBox(height: 5.w),
                                              Text(
                                                item.title,
                                                style: TextStyle(
                                                  fontSize: 17.w,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 5.w),
                                              Text(
                                                item.text,
                                                style: TextStyle(color: Colors.grey[800]),
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 5.w),
                                              Text(
                                                "created  $_created",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey,
                                                  fontSize: 12.w,
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
                          ));
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchNoteTextField() {
    return CupertinoSearchTextField(
      controller: _textController,
      focusNode: _focusNode,
      prefixInsets: const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 4),
      placeholder: 'Search notes',
    );
  }
}
