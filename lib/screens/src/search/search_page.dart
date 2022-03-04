import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:givnotes/packages/dynamic_text_highlighting.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/src/notes/src/notes_model.dart';
import 'package:givnotes/screens/src/notes/src/notes_repository.dart';
import 'package:givnotes/services/services.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  // List<NotesModel> _notes = [];
  final RxList<NotesModel> _searchList = <NotesModel>[].obs;

  @override
  void initState() {
    super.initState();

    _textController.addListener(() {
      final text = _textController.text;

      if (text.trim().isNotEmpty) {
        _searchList.clear();

        final filterList = Get.find<NotesController>()
            .notes
            .where((element) =>
                (element.title! + ' ' + element.text!)
                    .toLowerCase()
                    .contains(text.toLowerCase()) &&
                element.trash == false)
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
          padding:
              EdgeInsets.symmetric(horizontal: 0.035.sw, vertical: 0.025.sh),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [],
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
    );
  }

  void onSearchListItemSelected(NotesModel item) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    BlocProvider.of<NoteStatusCubit>(context).updateNoteMode(NoteMode.editing);
    Navigator.pushNamed(context, RouterName.editorRoute,
        arguments: [NoteMode.editing, item]);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HydratedPrefsState _prefsCubit =
        BlocProvider.of<HydratedPrefsCubit>(context).state;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
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
              child: Obx(() => _searchList.isEmpty
                  ? _textController.text.isEmpty
                      ? SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.all(0.05.sw),
                            child: Column(
                              children: [
                                SizedBox(height: 50.h),
                                Image.asset('assets/giv_img/search_light.png',
                                    height: 180.h),
                                'Search for your notes'
                                    .text
                                    .size(12.w)
                                    .make()
                                    .centered(),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: 'Ops! nothing found'
                              .text
                              .center
                              .italic
                              .light
                              .lg
                              .gray400
                              .make(),
                        )
                  : ListView.builder(
                      itemCount: _searchList.length,
                      itemBuilder: (context, index) {
                        final item = _searchList[index];
                        String _created = DateFormat.yMMMd()
                            .format(DateTime.parse(item.created!));

                        return Card(
                          elevation: 0,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(5),
                            onTap: () => onSearchListItemSelected(item),
                            onLongPress: () => onSearchListItemLongPress(item),
                            child: _textController.text.isNotEmpty
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 5.0.w),
                                        item.tags.isEmpty
                                            ? const SizedBox.shrink()
                                            : Container(
                                                margin:
                                                    EdgeInsets.only(top: 6.w),
                                                color: Colors.transparent,
                                                height: _prefsCubit.compactTags!
                                                    ? 8.h
                                                    : 18.h,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: item.tags.length,
                                                  itemBuilder: (cntx, index) {
                                                    String title =
                                                        item.tags[index];
                                                    Color color = Color(
                                                        VariableService()
                                                                .prefsBox
                                                                .allTagsMap![
                                                            title]!);

                                                    return _prefsCubit
                                                            .compactTags!
                                                        ? Container(
                                                            width: 30.w,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 5.w),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: color,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.r),
                                                            ),
                                                            child:
                                                                const SizedBox
                                                                    .shrink(),
                                                          )
                                                        : Container(
                                                            height: 18.h,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 5.w),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5.w),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: color,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.r),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                title,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  letterSpacing:
                                                                      0.5.w,
                                                                  fontSize: 8.w,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                  },
                                                ),
                                              ),
                                        SizedBox(height: 5.w),
                                        DynamicTextHighlighting(
                                          caseSensitive: false,
                                          highlights: [_textController.text],
                                          text: item.title!,
                                          style: TextStyle(
                                            fontSize: 18.w,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 5.w),
                                        DynamicTextHighlighting(
                                          caseSensitive: false,
                                          highlights: [_textController.text],
                                          text: item.text!,
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Poppins',
                                          ),
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
                                        const Divider(
                                            height: 0.0, thickness: 1.0),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        );
                      },
                    )),
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
