import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class TodoModel extends Equatable {
  final String id;
  final String title;
  final bool completed;
  final String description;
  final Timestamp dueDate;
  final String priority;

  // final Map<String, dynamic> category;
  final List<dynamic> subTask;
  final String category;
  final int categoryColor;

  TodoModel({
    String id,
    @required String title,
    this.completed,
    this.description = '',
    @required this.dueDate,
    this.priority,
    this.subTask,
    this.category = '',
    this.categoryColor,
  })  : this.title = title ?? '',
        this.id = id ?? Uuid().v1();

  TodoModel copyWith({
    String id,
    String title,
    bool completed,
    String description,
    Timestamp dueDate,
    String priority,
    List<dynamic> subTask,
    String category,
    int categoryColor,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      subTask: subTask ?? this.subTask,
      category: category ?? this.category,
      categoryColor: categoryColor ?? this.categoryColor,
    );
  }

  @override
  List<Object> get props => [
        this.id,
        this.title,
        this.completed,
        this.description,
        this.dueDate,
        this.priority,
        this.subTask,
        this.category,
        this.categoryColor
      ];

  @override
  int get hashCode =>
      this.id.hashCode ^
      this.title.hashCode ^
      this.completed.hashCode ^
      this.description.hashCode ^
      this.dueDate.hashCode ^
      this.priority.hashCode ^
      this.subTask.hashCode ^
      this.category.hashCode ^
      this.categoryColor.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoModel &&
          runtimeType == other.runtimeType &&
          this.id == other.id &&
          this.title == other.title &&
          this.completed == other.completed &&
          this.description == other.description &&
          this.dueDate == other.dueDate &&
          this.priority == other.priority &&
          this.subTask == other.subTask &&
          this.category == other.category &&
          this.categoryColor == other.categoryColor;

  @override
  String toString() {
    return 'TodoModel { id: $id, title: $title, completed: $completed, description: $description, dueDate: $dueDate, priority: $priority, subTask: $subTask, category: $category, categoryColor: $categoryColor }';
  }

  static TodoModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    return TodoModel(
      id: snap.data()['id'] as String,
      title: snap.data()['title'] as String,
      completed: snap.data()['completed'] as bool,
      description: snap.data()['description'] as String,
      dueDate: snap.data()['dueDate'] as Timestamp,
      priority: snap.data()['priority'] as String,
      subTask: snap.data()['subTask'],
      category: snap.data()['category'] as String,
      categoryColor: snap.data()['categoryColor'] as int,
    );
  }

  Map<String, Object> toDocument() {
    return {
      "id": this.id,
      "title": this.title,
      "completed": this.completed,
      "description": this.description,
      "dueDate": this.dueDate,
      "priority": this.priority,
      "subTask": this.subTask,
      "category": this.category,
      "categoryColor": this.categoryColor,
    };
  }

  // static TodoEntity fromJson(Map<String, Object> json) {
  //   return TodoEntity(
  //     json["id"] as String,
  //     json["title"] as String,
  //     json["completed"] as bool,
  //     json["description"] as String,
  //     json["dueDate"] as Timestamp,
  //     json["priority"] as String,
  //     json["subTask"] as List<dynamic>,
  //     json["category"] as String,
  //     json["categoryColor"] as int,
  //   );
  // }

  // _TodoEntity toEntity() {
  //   return TodoEntity(id, title, completed, description, dueDate, priority, subTask, category, categoryColor);
  // }

  // static TodoModel fromEntity(TodoEntity entity) {
  //   return TodoModel(
  //     id: entity.id,
  //     title: entity.title,
  //     completed: entity.completed,
  //     description: entity.description,
  //     dueDate: entity.dueDate,
  //     priority: entity.priority,
  //     subTask: entity.subTask,
  //     category: entity.category,
  //     categoryColor: entity.categoryColor,
  //   );
  // }

  // Future<List<dynamic>> updateSubTask(int index) async {
  //   var subMap = subTask[index];
  //   subMap[subMap.keys.first] = !subMap.values.first;
  //   return subTask;
  // }

  // Map<String, dynamic> updateCategory(int value) {
  //   category[category.keys.first] = value;
  //   return category;
  // }
}
