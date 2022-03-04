// ignore_for_file: file_names

import 'package:hive/hive.dart';

part 'HiveDB.g.dart';

// @HiveType(typeId: 0)
// class NotesModel extends HiveObject {
//   @HiveField(0)
//   String id;

//   @HiveField(1)
//   String title;

//   @HiveField(2)
//   String text;

//   @HiveField(3)
//   String znote;

//   @HiveField(4)
//   bool trash = false;

//   @HiveField(5)
//   DateTime created;

//   @HiveField(6)
//   DateTime modified;

//   @HiveField(7)
//   List<String> tagsNameList = <String>[];
// }

@HiveType(typeId: 0)
class PrefsModel extends HiveObject {
  @HiveField(0)
  bool? biometric = false;

  @HiveField(1)
  String? passcode = '';

  @HiveField(2)
  Map<String, int>? allTagsMap = {};
}
