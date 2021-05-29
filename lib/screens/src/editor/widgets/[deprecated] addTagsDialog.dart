// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:velocity_x/velocity_x.dart';

// import 'package:givnotes/global/material_colors.dart';
// import 'package:givnotes/global/variables.dart';
// import 'package:givnotes/screens/screens.dart';

// import '../editor_screen.dart';

// class AddTagsDialog extends StatefulWidget {
//   AddTagsDialog({
//     Key key,
//     @required this.editNoteTag,
//     @required this.editTagTitle,
//     @required this.updateTags,
//   }) : super(key: key);

//   final bool editNoteTag;
//   final String editTagTitle;
//   final VoidCallback updateTags;

//   @override
//   _AddTagsDialogState createState() => _AddTagsDialogState();
// }

// class _AddTagsDialogState extends State<AddTagsDialog> {
//   int colorValue = 0;
//   Map<String, int> _allTagsMap = {};
//   final TextEditingController _newTagTextController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _allTagsMap = prefsBox.allTagsMap;

//     if (widget.editTagTitle.isNotEmpty) {
//       selectTagColors
//         ..clear()
//         ..add(_allTagsMap[widget.editTagTitle]);
//     } else {
//       selectTagColors
//         ..clear()
//         ..addAll(materialColorValues);
//     }

//     _newTagTextController.text = widget.editTagTitle;

//     _newTagTextController.addListener(() {
//       final text = _newTagTextController.text.trim();

//       if (text.isNotEmpty) {
//         final filterList = _allTagsMap.keys.where((element) => element.contains(text)).toList();
//         final List<int> filterColorList = [];

//         filterList.forEach((element) {
//           if (element == text) filterColorList.add(_allTagsMap[element]);
//         });

//         if (filterColorList.isNotEmpty) {
//           setState(() {
//             selectTagColors
//               ..clear()
//               ..addAll(filterColorList);
//           });
//         } else {
//           setState(() {
//             selectTagColors
//               ..clear()
//               ..addAll(materialColorValues);
//           });
//         }
//       } else {
//         selectTagColors
//           ..clear()
//           ..addAll(materialColorValues);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     // TODO every time new tag dialog shows it fetches and puts allTagsMap in HiveDB
//     //! IMPROVE
//     prefsBox.allTagsMap = _allTagsMap;
//     prefsBox.save();

//     //TODO also the listner is also added and removed every time
//     _newTagTextController?.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // width: (335.w),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextField(
//             controller: _newTagTextController,
//             autocorrect: false,
//             cursorColor: Colors.black,
//             textCapitalization: TextCapitalization.characters,
//             inputFormatters: [
//               TextInputFormatter.withFunction(
//                 (oldValue, newValue) => TextEditingValue(
//                   text: newValue.text?.toUpperCase(),
//                   selection: newValue.selection,
//                 ),
//               ),
//             ],
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: Colors.grey[200],
//               focusColor: Colors.grey,
//               labelText: 'Tag name',
//               labelStyle: TextStyle(
//                 fontSize: 16.w,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[600],
//               ),
//               enabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Colors.grey[800],
//                   width: 2.5,
//                 ),
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
//               ),
//               focusedBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Colors.grey[800],
//                   width: 2.5,
//                 ),
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
//               ),
//             ),
//           ),
//           SizedBox(height: 25.h),
//           Text(
//             'Tag color: ',
//             style: TextStyle(
//               fontSize: 18.w,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//           ),
//           Container(
//             height: 70.h,
//             color: Colors.transparent,
//             width: 335.w,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.all(0),
//               itemCount: selectTagColors.length,
//               itemBuilder: (context, index) {
//                 Color color = Color(selectTagColors[index]);

//                 return Padding(
//                   padding: EdgeInsets.only(right: 5.w),
//                   child: GestureDetector(
//                     onTap: () {
//                       if (selectTagColors.length == 1 && !_allTagsMap.containsKey(_newTagTextController.text.trim())) {
//                         setState(() {
//                           selectTagColors
//                             ..clear()
//                             ..addAll(materialColorValues);
//                         });
//                       } else if (_allTagsMap.containsKey(_newTagTextController.text.trim())) {
//                         showFlashToast(context, "Tag already exists...");
//                       } else {
//                         setState(() {
//                           selectTagColors
//                             ..clear()
//                             ..add(color.value);
//                         });
//                       }
//                     },
//                     child: Material(
//                       elevation: 4.0,
//                       shape: const CircleBorder(),
//                       child: CircleAvatar(
//                         radius: 45 / 2,
//                         backgroundColor: color,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 10.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 height: 60.h,
//                 width: 90.w,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     elevation: 0.0,
//                     primary: Colors.grey[200],
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
//                   ),
//                   onPressed: () {
//                     _newTagTextController.clear();
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     'CANCEL',
//                     style: TextStyle(
//                       color: Color(0xff1F1F1F),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 15.w),
//               Container(
//                 height: 60.h,
//                 width: 90.w,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     elevation: 0.0,
//                     primary: Colors.black,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
//                   ),
//                   child: Text(
//                     'SAVE',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   onPressed: () {
//                     int flag = 0;
//                     String tagName = _newTagTextController.text.trim();

//                     if (tagName.isEmpty) {
//                       showFlashToast(context, 'Tag name is required');
//                       //
//                     } else if (selectTagColors.length != 1) {
//                       showFlashToast(context, 'Please select a color');
//                     } else {
//                       colorValue = selectTagColors.first;

//                       if (widget.editNoteTag) {
//                         if (tagName != widget.editTagTitle) {
//                           noteTagsMap.remove(widget.editTagTitle);
//                           _allTagsMap.remove(widget.editTagTitle);
//                         }
//                         noteTagsMap[tagName] = colorValue;
//                         _allTagsMap[tagName] = colorValue;

//                         Get.find<TagSearchController>().tagSearchList
//                           ..clear()
//                           ..addAll(_allTagsMap.keys.toList());
//                         //
//                       } else {
//                         if (!_allTagsMap.containsKey(tagName)) {
//                           _allTagsMap[tagName] = colorValue;

//                           Get.find<TagSearchController>().tagSearchList
//                             ..clear()
//                             ..addAll(_allTagsMap.keys.toList());
//                         } else {
//                           flag = _allTagsMap[tagName];
//                         }

//                         if (!noteTagsMap.containsKey(tagName)) {
//                           if (flag == 0)
//                             noteTagsMap[tagName] = colorValue;
//                           else
//                             noteTagsMap[tagName] = flag;
//                         } else {
//                           showFlashToast(context, "Tag already added");
//                         }
//                       }

//                       _newTagTextController.clear();
//                       widget.updateTags();

//                       Navigator.pop(context);
//                     }
//                   },
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// List<int> selectTagColors = [];

// showDialog(
//   context: context,
//   builder: (BuildContext context) {
//     return AlertDialog(
//       insetPadding: EdgeInsets.all(10),
//       title: Text('Edit tag'),
//       titlePadding: EdgeInsets.all(15.w),
//       titleTextStyle: TextStyle(
//         fontSize: 22.w,
//         fontWeight: FontWeight.bold,
//         color: Colors.black,
//         letterSpacing: 0.5.w,
//       ),
//       contentPadding: EdgeInsets.all(15.w),
//       content: AddTagScreen(
//         controller: _tagController,
//         isEditing: true,
//         editTagTitle: item.title,
//         updateTags: () => setState(() {}),
//       ),
//     );
//   },
// );