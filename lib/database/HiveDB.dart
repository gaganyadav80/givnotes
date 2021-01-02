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
}

@HiveType(typeId: 1)
class PrefsModel extends HiveObject {
  @HiveField(0)
  bool isAnonymous = false;

  @HiveField(1)
  bool firstlaunch = false;

  @HiveField(2)
  bool applock = false;

  @HiveField(3)
  bool biometric = false;

  // @HiveField(4)
  // bool compactTags = false;

  // 'created', 'modified', 'a-z', 'z-a'
  // @HiveField(5)
  // String sortBy = 'created';

  @HiveField(6)
  String passcode = '';

  @HiveField(7)
  Map<String, int> allTagsMap = {};
}
