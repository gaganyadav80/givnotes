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
  })  : title = title ?? '',
        id = id ?? const Uuid().v1();

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
        id,
        title,
        completed,
        description,
        dueDate,
        priority,
        subTask,
        category,
        categoryColor
      ];

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      completed.hashCode ^
      description.hashCode ^
      dueDate.hashCode ^
      priority.hashCode ^
      subTask.hashCode ^
      category.hashCode ^
      categoryColor.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          completed == other.completed &&
          description == other.description &&
          dueDate == other.dueDate &&
          priority == other.priority &&
          subTask == other.subTask &&
          category == other.category &&
          categoryColor == other.categoryColor;

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
      "id": id,
      "title": title,
      "completed": completed,
      "description": description,
      "dueDate": dueDate,
      "priority": priority,
      "subTask": subTask,
      "category": category,
      "categoryColor": categoryColor,
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
