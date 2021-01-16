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

  @HiveField(4)
  String passcode = '';

  @HiveField(5)
  Map<String, int> allTagsMap = {};
}

@HiveType(typeId: 2)
class TodoModel extends HiveObject {
  @HiveField(0)
  String uuid;

  @HiveField(1)
  String category;

  @HiveField(2)
  int color;

  @HiveField(3)
  int icon;

  @HiveField(4)
  List<TaskObject> tasks;

  int taskAmount() => tasks.length;

  double percentComplete() {
    if (tasks.isEmpty) {
      return 1.0;
    }
    int completed = 0;
    int amount = tasks.length;
    tasks.forEach((element) {
      if (element.isCompleted()) {
        completed++;
      }
    });
    return completed / amount;
  }
}

@HiveType(typeId: 3)
class TaskObject extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final String task;

  @HiveField(2)
  bool completed;

  TaskObject(this.task, this.date, {this.completed = false});

  void setComplete(bool value) {
    completed = value;
  }

  isCompleted() => completed;
}
