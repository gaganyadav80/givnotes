import 'package:hive/hive.dart';

part 'HiveDB.g.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String text;

  @HiveField(2)
  String znote;

  @HiveField(3)
  bool trash = false;

  @HiveField(4)
  DateTime created;

  @HiveField(5)
  DateTime modified;

  @HiveField(6)
  Map<String, int> tagsMap = {};

  // @HiveField(6)
  // List<String> tags = [];

  // @HiveField(7)
  // List<int> tagColor = [];
}

// @HiveType(typeId: 1)
// class PrefsModel extends HiveObject {
//   @HiveField(0)
//   bool skip;

//   @HiveField(1)
//   bool firstlaunch;

//   @HiveField(2)
//   bool applock;

//   @HiveField(3)
//   bool biometric;

//   @HiveField(4)
//   List<String> searchlist;

//   @HiveField(5)
//   Map<String, String> user;

//   Map<String, dynamic> toJson() {
//     return {
//       'skip': skip,
//       'firstlaunch': firstlaunch,
//       'applock': applock,
//       'biometric': biometric,
//       'searchlist': searchlist,
//       'user': user,
//     };
//   }
// }
