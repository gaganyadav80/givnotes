import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/cubit/note_search_cubit/note_search_cubit.dart';
import 'package:givnotes/global/material_colors.dart';
import 'package:givnotes/global/size_utils.dart';
import 'package:givnotes/global/variables.dart';

import '../zefyrEdit.dart';

class AddTagsDialog extends StatefulWidget {
  AddTagsDialog({
    Key key,
    @required this.editNoteTag,
    @required this.editTagTitle,
  }) : super(key: key);

  final bool editNoteTag;
  final String editTagTitle;

  @override
  _AddTagsDialogState createState() => _AddTagsDialogState();
}

class _AddTagsDialogState extends State<AddTagsDialog> {
  final TextEditingController _newTagTextController = TextEditingController();

  int colorValue = 0;
  Map<String, int> _allTagsMap = {};

  @override
  void initState() {
    super.initState();
    _allTagsMap = prefsBox.allTagsMap;

    if (widget.editTagTitle.isNotEmpty) {
      selectTagColors
        ..clear()
        ..add(_allTagsMap[widget.editTagTitle]);
    } else {
      selectTagColors
        ..clear()
        ..addAll(materialColorValues);
    }

    _newTagTextController.text = widget.editTagTitle;

    _newTagTextController.addListener(() {
      final text = _newTagTextController.text.trim();

      if (text.isNotEmpty) {
        final filterList = _allTagsMap.keys.where((element) => element.contains(text)).toList();
        final List<int> filterColorList = [];

        filterList.forEach((element) {
          if (element == text) filterColorList.add(_allTagsMap[element]);
        });

        if (filterColorList.isNotEmpty) {
          setState(() {
            selectTagColors
              ..clear()
              ..addAll(filterColorList);
          });
        } else {
          setState(() {
            selectTagColors
              ..clear()
              ..addAll(materialColorValues);
          });
        }
      } else {
        selectTagColors
          ..clear()
          ..addAll(materialColorValues);
      }
    });
  }

  @override
  void dispose() {
    // TODO every time new tag dialog shows it fetches and puts allTagsMap in HiveDB
    //! IMPROVE
    prefsBox.allTagsMap = _allTagsMap;
    prefsBox.save();

    //TODO also the listner is also added and removed every time
    _newTagTextController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _noteEditStore = BlocProvider.of<NoteAndSearchCubit>(context);
    return Container(
      height: 0.342105263 * screenSize.height, //260
      width: (screenSize.width * 0.85),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _newTagTextController,
            autocorrect: false,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              TextInputFormatter.withFunction(
                (oldValue, newValue) => TextEditingValue(
                  text: newValue.text?.toUpperCase(),
                  selection: newValue.selection,
                ),
              ),
            ],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              focusColor: Colors.grey,
              labelText: 'Tag name',
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[800],
                  width: 2.5,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[800],
                  width: 2.5,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
            ),
          ),
          // SizedBox(height: 25),
          SizedBox(height: 0.032894737 * screenSize.height),
          Text(
            'Tag color: ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          // SizedBox(width: 5),
          Container(
            // height: 70,
            height: 0.092105263 * screenSize.height,
            color: Colors.transparent,
            width: (MediaQuery.of(context).size.width * 0.85),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(0),
              itemCount: selectTagColors.length,
              itemBuilder: (context, index) {
                Color color = Color(selectTagColors[index]);

                return Padding(
                  // padding: const EdgeInsets.only(right: 5),
                  padding: EdgeInsets.only(right: 0.012690355 * screenSize.width),
                  child: GestureDetector(
                    onTap: () {
                      if (selectTagColors.length == 1 && !_allTagsMap.containsKey(_newTagTextController.text.trim())) {
                        setState(() {
                          selectTagColors
                            ..clear()
                            ..addAll(materialColorValues);
                        });
                      } else if (_allTagsMap.containsKey(_newTagTextController.text.trim())) {
                        showFlashToast(context, "Tag already exists...");
                      } else {
                        setState(() {
                          selectTagColors
                            ..clear()
                            ..add(color.value);
                        });
                      }
                    },
                    child: Material(
                      elevation: 4.0,
                      shape: const CircleBorder(),
                      child: CircleAvatar(
                        radius: 45 / 2,
                        backgroundColor: color,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // SizedBox(height: 10),
          SizedBox(height: 0.013157895 * screenSize.height),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                // height: 45,
                // width: 90,
                height: 0.059210526 * screenSize.height,
                width: 0.228426396 * screenSize.width,
                child: RaisedButton(
                  elevation: 0,
                  onPressed: () {
                    Navigator.pop(context);
                    _newTagTextController.clear();
                  },
                  color: Colors.grey[200],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: Color(0xff1F1F1F),
                      fontWeight: FontWeight.w600,
                      // letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              // SizedBox(width: 15),
              SizedBox(width: 0.038071066 * screenSize.width),
              Container(
                // height: 45,
                // width: 90,
                height: 0.059210526 * screenSize.height,
                width: 0.228426396 * screenSize.width,
                child: RaisedButton(
                  elevation: 0,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      // letterSpacing: 0.5,
                    ),
                  ),
                  onPressed: () {
                    int flag = 0;
                    String tagName = _newTagTextController.text.trim();

                    if (tagName.isEmpty) {
                      showFlashToast(context, 'Tag name is required');
                      //
                    } else if (selectTagColors.length != 1) {
                      showFlashToast(context, 'Please select a color');
                    } else {
                      colorValue = selectTagColors.first;

                      if (widget.editNoteTag) {
                        if (tagName != widget.editTagTitle) {
                          noteTagsMap.remove(widget.editTagTitle);
                          _allTagsMap.remove(widget.editTagTitle);
                        }
                        noteTagsMap[tagName] = colorValue;
                        _allTagsMap[tagName] = colorValue;
                        //
                      } else {
                        if (!_allTagsMap.containsKey(tagName)) {
                          _allTagsMap[tagName] = colorValue;
                        } else {
                          flag = _allTagsMap[tagName];
                        }

                        if (!noteTagsMap.containsKey(tagName)) {
                          if (flag == 0)
                            noteTagsMap[tagName] = colorValue;
                          else
                            noteTagsMap[tagName] = flag;
                        } else {
                          showFlashToast(context, "Tag already added");
                        }
                      }

                      _noteEditStore.updateIsEditing(true);
                      _newTagTextController.clear();

                      Navigator.pop(context);
                    }
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

List<int> selectTagColors = [];
