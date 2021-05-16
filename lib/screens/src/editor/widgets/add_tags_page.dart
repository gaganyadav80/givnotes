import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/global/material_colors.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/screens/src/tags_view.dart';

import '../editor_screen.dart';

class AddTagScreen extends StatefulWidget {
  AddTagScreen({
    Key key,
    this.controller,
    this.isEditing,
    this.editTagTitle,
    this.updateTags,
  }) : super(key: key);

  final TextEditingController controller;
  final bool isEditing;
  final String editTagTitle;
  final VoidCallback updateTags;

  @override
  _AddTagScreenState createState() => _AddTagScreenState();
}

class _AddTagScreenState extends State<AddTagScreen> {
  static const CupertinoDynamicColor _kClearButtonColor = CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0x33FFFFFF),
  );

  final FocusNode _focusNode = FocusNode();
  final RxInt tagColor = 0.obs;
  Map<String, int> _allTagsMap = {};

  @override
  void initState() {
    super.initState();
    _allTagsMap = prefsBox.allTagsMap;

    if (widget.editTagTitle.isNotEmpty && widget.isEditing) {
      tagColor.value = _allTagsMap[widget.editTagTitle];
      widget.controller.text = widget.editTagTitle;
    } else {
      tagColor.value = materialColorValues[0];
    }

    widget.controller.addListener(() {
      final text = widget.controller.text.trim();

      if (text.isNotEmpty) {
        final String filterTagName = _allTagsMap.keys.firstWhere(
          (element) => element == text,
          orElse: () => null,
        );

        if (filterTagName != null) {
          tagColor.value = _allTagsMap[filterTagName];
        }
      }
    });
  }

  @override
  void dispose() {
    prefsBox.allTagsMap = _allTagsMap;
    prefsBox.save();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: onDone,
        child: CupertinoPageScaffold(
          backgroundColor: Color(0xffF7F6F2),
          navigationBar: CupertinoNavigationBar(
            automaticallyImplyLeading: false,
            middle: Text("Add Tag"),
            trailing: TextButton(
              child: Text(
                'Done',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: onDone,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30.w),
                  Container(
                    height: 45.w,
                    color: Colors.white,
                    child: Center(
                      child: CupertinoTextField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        cursorColor: Colors.black,
                        placeholder: "Add tag name",
                        padding: const EdgeInsets.fromLTRB(15.0, 6.0, 6.0, 6.0),
                        textCapitalization: TextCapitalization.sentences,
                        decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                        suffixMode: OverlayVisibilityMode.editing,
                        suffix: GestureDetector(
                          onTap: () => widget.controller.clear(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(
                              CupertinoIcons.clear_thick_circled,
                              size: 18.0,
                              color: CupertinoDynamicColor.resolve(_kClearButtonColor, context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.w),
                  GestureDetector(
                    onTap: () {
                      if (widget.isEditing) {
                        if (noteTagsMap.containsKey(widget.controller.text)) {
                          noteTagsMap.remove(widget.controller.text);
                        }
                        if (_allTagsMap.containsKey(widget.controller.text)) {
                          _allTagsMap.remove(widget.controller.text);
                        }
                      }
                      widget.controller.clear();
                      tagColor.value = materialColorValues[0];
                      Navigator.pop(context, false);
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 15.0),
                      height: 45.w,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            !widget.isEditing ? CupertinoIcons.clear : CupertinoIcons.delete,
                            color: Colors.black,
                            size: 21.0,
                          ),
                          SizedBox(width: 10.w),
                          "${!widget.isEditing ? "Cancel" : "Delete"}".text.size(16.w).make(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 20.w,
                      child: "COLORS".text.coolGray400.size(10.w).make(),
                    ).pSymmetric(h: 15.0),
                  ),
                  Container(
                    color: Colors.white,
                    child: Obx(() => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            10,
                            (index) => GestureDetector(
                              onTap: () {
                                tagColor.value = materialColorValues[index];
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 15.0),
                                height: 45.w,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 25.w,
                                          width: 25.w,
                                          decoration: BoxDecoration(
                                            color: Color(materialColorValues[index]).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(3.r),
                                            border:
                                                Border.all(color: Color(materialColorValues[index]).withOpacity(0.2)),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        materialColorNames[index].text.size(16.w).make(),
                                      ],
                                    ),
                                    if (tagColor.value == materialColorValues[index])
                                      Icon(CupertinoIcons.checkmark_alt, color: Colors.black).pOnly(right: 15.w),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onDone() async {
    int flag = 0;
    String tagName = widget.controller.text.trim();

    if (tagName.isEmpty) {
      Fluttertoast.showToast(msg: "Tag name is required");
    } else {
      if (widget.isEditing) {
        if (tagName != widget.editTagTitle) {
          noteTagsMap.remove(widget.editTagTitle);
          _allTagsMap.remove(widget.editTagTitle);
        }
        noteTagsMap[tagName] = tagColor.value;
        _allTagsMap[tagName] = tagColor.value;

        Get.find<TagSearchController>().tagSearchList
          ..clear()
          ..addAll(_allTagsMap.keys.toList());
      } else {
        if (!_allTagsMap.containsKey(tagName)) {
          _allTagsMap[tagName] = tagColor.value;

          Get.find<TagSearchController>().tagSearchList
            ..clear()
            ..addAll(_allTagsMap.keys.toList());
        } else {
          flag = _allTagsMap[tagName];
        }

        if (!noteTagsMap.containsKey(tagName)) {
          if (flag == 0)
            noteTagsMap[tagName] = tagColor.value;
          else
            noteTagsMap[tagName] = flag;
        } else {
          Fluttertoast.showToast(msg: "Tag already added");
        }
      }
      widget.controller.clear();
      widget.updateTags();
    }
    Navigator.pop(context);

    return false;
  }
}
