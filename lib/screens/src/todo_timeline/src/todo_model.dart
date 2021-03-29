import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import 'todo_entity.dart';

class Todo {
  final String id;
  final String title;
  final bool completed;
  final String description;
  final Timestamp dueDate;
  final String priority;

  final Map<String, dynamic> category;
  final List<dynamic> subTask;

  Todo({
    String id,
    @required String title,
    this.completed,
    this.description = '',
    @required this.dueDate,
    this.priority,
    this.subTask,
    this.category,
  })  : this.title = title ?? '',
        this.id = id ?? Uuid().v1();

  Todo copyWith({
    String id,
    String title,
    bool completed,
    String description,
    Timestamp dueDate,
    String priority,
    List<dynamic> subTask,
    Map<String, dynamic> category,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      subTask: subTask ?? this.subTask,
      category: category ?? this.category,
    );
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ completed.hashCode ^ description.hashCode ^ dueDate.hashCode ^ priority.hashCode ^ subTask.hashCode ^ category.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          completed == other.completed &&
          description == other.description &&
          dueDate == other.dueDate &&
          priority == other.priority &&
          subTask == other.subTask &&
          category == other.category;

  @override
  String toString() {
    return 'Todo { id: $id, title: $title, completed: $completed, description: $description, dueDate: $dueDate, priority: $priority, subTask: $subTask, category: $category }';
  }

  TodoEntity toEntity() {
    return TodoEntity(id, title, completed, description, dueDate, priority, subTask, category);
  }

  static Todo fromEntity(TodoEntity entity) {
    return Todo(
      id: entity.id,
      title: entity.title,
      completed: entity.completed,
      description: entity.description,
      dueDate: entity.dueDate,
      priority: entity.priority,
      subTask: entity.subTask,
      category: entity.category,
    );
  }

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
