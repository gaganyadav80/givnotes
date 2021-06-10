import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/screens/src/tags_view.dart';
import 'package:givnotes/services/services.dart';

class AddTagScreen extends StatefulWidget {
  AddTagScreen({
    Key key,
    this.controller,
    this.isEditing,
    this.editTagTitle,
    this.updateTags,
    @required this.noteTagsList,
  }) : super(key: key);

  final TextEditingController controller;
  final bool isEditing;
  final String editTagTitle;
  final VoidCallback updateTags;
  final RxList<String> noteTagsList;

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
  final VariableService _global = VariableService();
  final MaterialColors _colors = MaterialColors();

  @override
  void initState() {
    super.initState();
    if (widget.editTagTitle.isNotEmpty && widget.isEditing) {
      tagColor.value = _global.prefsBox.allTagsMap[widget.editTagTitle];
      widget.controller.text = widget.editTagTitle;
    } else {
      tagColor.value = _colors.materialColorValues[0];
    }

    widget.controller.addListener(() {
      final text = widget.controller.text.trim();

      if (text.isNotEmpty) {
        final String filterTagName = _global.prefsBox.allTagsMap.keys.firstWhere(
          (element) => element == text,
          orElse: () => null,
        );

        if (filterTagName != null) {
          tagColor.value = _global.prefsBox.allTagsMap[filterTagName];
        }
      }
    });
  }

  @override
  void dispose() {
    _global.prefsBox.save();
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
            leading: widget.isEditing
                ? IconButton(
                    icon: Icon(CupertinoIcons.xmark_circle_fill),
                    color: CupertinoColors.systemGrey3,
                    onPressed: () {
                      widget.controller.clear();
                      Navigator.pop(context, false);
                    },
                  )
                : SizedBox.shrink(),
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
                        if (widget.noteTagsList.contains(widget.controller.text)) {
                          widget.noteTagsList.remove(widget.controller.text);
                        }
                        // if (Get.find<TagSearchController>().tagSearchList.contains(widget.controller.text)) {
                        //   Get.find<TagSearchController>().tagSearchList.remove(widget.controller.text);
                        // }
                        // if (_global.prefsBox.allTagsMap.containsKey(widget.controller.text)) {
                        //   _global.prefsBox.allTagsMap.remove(widget.controller.text);
                        // }

                        widget.updateTags();
                      }
                      widget.controller.clear();
                      tagColor.value = _colors.materialColorValues[0];
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
                                tagColor.value = _colors.materialColorValues[index];
                                if (_global.prefsBox.allTagsMap.containsKey(widget.controller.text) &&
                                    tagColor.value != _global.prefsBox.allTagsMap[widget.controller.text] &&
                                    !widget.isEditing) {
                                  Fluttertoast.showToast(
                                      msg: 'Tag already exists. This will change the color of the existing tag');
                                }
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
                                            color: Color(_colors.materialColorValues[index]).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(3.r),
                                            border: Border.all(
                                                color: Color(_colors.materialColorValues[index]).withOpacity(0.2)),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        _colors.materialColorNames[index].text.size(16.w).make(),
                                      ],
                                    ),
                                    if (tagColor.value == _colors.materialColorValues[index])
                                      Icon(CupertinoIcons.checkmark_alt, color: Colors.black).pOnly(right: 15.w)
                                    else if (_global.prefsBox.allTagsMap.containsKey(widget.controller.text) &&
                                        _colors.materialColorValues[index] ==
                                            _global.prefsBox.allTagsMap[widget.controller.text])
                                      'Current'.text.xs.gray400.make().pOnly(right: 15.w),
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
    String tagName = widget.controller.text.trim();

    if (tagName.isEmpty) {
      Fluttertoast.showToast(msg: "Tag name is required");
    } else {
      if (widget.isEditing) {
        if (tagName != widget.editTagTitle) {
          widget.noteTagsList.remove(widget.editTagTitle);
          _global.prefsBox.allTagsMap.remove(widget.editTagTitle);
        }
        // noteTagsMap[tagName] = tagColor.value;
        if (!widget.noteTagsList.contains(tagName)) widget.noteTagsList.add(tagName);
        _global.prefsBox.allTagsMap[tagName] = tagColor.value;

        Get.find<TagSearchController>().tagSearchList
          ..clear()
          ..addAll(_global.prefsBox.allTagsMap.keys.toList());
      } else {
        if (!_global.prefsBox.allTagsMap.containsKey(tagName)) {
          _global.prefsBox.allTagsMap[tagName] = tagColor.value;

          Get.find<TagSearchController>().tagSearchList
            ..clear()
            ..addAll(_global.prefsBox.allTagsMap.keys.toList());
        }
        _global.prefsBox.allTagsMap[tagName] = tagColor.value;

        if (!widget.noteTagsList.contains(tagName)) {
          widget.noteTagsList.add(tagName);
          // noteTagsMap[tagName] = tagColor.value;
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
