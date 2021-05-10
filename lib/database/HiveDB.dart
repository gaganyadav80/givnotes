import 'package:hive/hive.dart';

part 'HiveDB.g.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String text;

  @HiveField(3)
  String znote;

  @HiveField(4)
  bool trash = false;

  @HiveField(5)
  DateTime created;

  @HiveField(6)
  DateTime modified;

  @HiveField(7)
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

  @HiveField(4)
  String passcode = '';

  @HiveField(5)
  Map<String, int> allTagsMap = {};
}
