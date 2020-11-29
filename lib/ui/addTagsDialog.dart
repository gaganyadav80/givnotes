import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:givnotes/packages/toast.dart';
import 'package:givnotes/pages/zefyrEdit.dart';
// import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/variables/prefs.dart';

class AddTagsDialog extends StatefulWidget {
  AddTagsDialog({
    Key key,
    @required this.editNoteTag,
    @required this.editTagTitle,
    @required this.setZefyrState,
  }) : super(key: key);

  final bool editNoteTag;
  final String editTagTitle;
  final Function setZefyrState;

  // final TextEditingController addTagController;
  // final Map<String, int> allTagsMap;

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
    _allTagsMap = (prefsBox.get('allTagsMap') as Map).cast<String, int>();

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
    prefsBox.put('allTagsMap', _allTagsMap);

    //TODO also the listner is also added and removed every time
    _newTagTextController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: (MediaQuery.of(context).size.width * 0.85),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'New tag',
          //   style: TextStyle(
          //     fontSize: 22,
          //     fontWeight: FontWeight.bold,
          //     letterSpacing: 0.5,
          //   ),
          // ),
          // SizedBox(height: 20),
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
          SizedBox(height: 25),
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
            height: 70,
            color: Colors.transparent,
            width: (MediaQuery.of(context).size.width * 0.85),
            // child: MaterialColorPicker(
            //   onMainColorChange: (color) {
            //     colorValue = color.value;
            //   },
            //   allowShades: false,
            //   selectedColor: Color(colorValue),
            // ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(0),
              itemCount: selectTagColors.length,
              itemBuilder: (context, index) {
                Color color = Color(selectTagColors[index]);

                return Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: GestureDetector(
                    onTap: () {
                      if (selectTagColors.length == 1 && !_allTagsMap.containsKey(_newTagTextController.text.trim())) {
                        setState(() {
                          selectTagColors
                            ..clear()
                            ..addAll(materialColorValues);
                        });
                      } else if (_allTagsMap.containsKey(_newTagTextController.text.trim())) {
                        showToast("Tag already exists...");
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
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 45,
                width: 90,
                child: RaisedButton(
                  elevation: 0,
                  onPressed: () {
                    // widget.editNoteTag = false;
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
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Container(
                height: 45,
                width: 90,
                child: RaisedButton(
                  elevation: 0,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  onPressed: () {
                    int flag = 0;
                    String tagName = _newTagTextController.text.trim();

                    if (tagName.isEmpty) {
                      // showToast("Tag name is required");
                      // zefyrScaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Tag name is required')));
                      // OneContext().showSnackBar(
                      //   builder: (_) => SnackBar(content: Text('My awesome snackBar!')),
                      // );
                      showFlashToast(context, 'Tag name is required');
                      //
                    } else if (selectTagColors.length != 1) {
                      // showToast("Please select a color");
                      showFlashToast(context, 'Please select a color');
                    } else {
                      colorValue = selectTagColors.first;

                      if (widget.editNoteTag) {
                        if (tagName != widget.editTagTitle) {
                          noteTagsMap.remove(widget.editTagTitle);
                          // _noteTagsMap.remove(widget.editTagTitle);
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
                          // showToast("Tag already added");
                          showFlashToast(context, "Tag already added");
                        }
                      }

                      // setState(() {});
                      widget.setZefyrState(true);
                      _newTagTextController.clear();

                      Navigator.pop(context);
                      // editNoteTag = false;
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

  void showToast(String msg) {
    Toast.show(
      msg,
      context,
      duration: 3,
      gravity: Toast.TOP,
      backgroundColor: Colors.grey[800],
      backgroundRadius: 5,
    );
  }
}

List<int> selectTagColors = [];

final List<int> materialColorValues = <int>[
  Colors.red.value,
  Colors.pink.value,
  Colors.purple.value,
  Colors.deepPurple.value,
  Colors.indigo.value,
  Colors.blue.value,
  Colors.lightBlue.value,
  Colors.cyan.value,
  Colors.teal.value,
  Colors.green.value,
  Colors.lightGreen.value,
  Colors.lime.value,
  Colors.yellow.value,
  Colors.amber.value,
  Colors.orange.value,
  Colors.deepOrange.value,
  Colors.brown.value,
  Colors.grey.value,
  Colors.blueGrey.value,
];
