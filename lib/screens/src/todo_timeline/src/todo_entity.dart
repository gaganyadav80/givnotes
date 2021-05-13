// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final String id;
  final String title;
  final bool completed;
  final String description;
  final Timestamp dueDate;
  final String priority;
  final List<dynamic> subTask;
  final Map<String, dynamic> category;

  TodoEntity(
    this.id,
    this.title,
    this.completed,
    this.description,
    this.dueDate,
    this.priority,
    this.subTask,
    this.category,
  );

  Map<String, Object> toJson() {
    return {
      "id": id,
      "title": title,
      "completed": completed,
      "description": description,
      "dueDate": dueDate,
      "priority": priority,
      "subTask": subTask,
      "category": category,
    };
  }

  @override
  List<Object> get props => [id, title, completed, description, dueDate, priority, subTask, category];

  @override
  String toString() {
    return 'TodoEntity { id: $id, title: $title, completed: $completed, description: $description, dueDate: $dueDate, priority: $priority, subTask: $subTask, category: $category }';
  }

  static TodoEntity fromJson(Map<String, Object> json) {
    return TodoEntity(
      json["id"] as String,
      json["title"] as String,
      json["completed"] as bool,
      json["description"] as String,
      json["dueDate"] as Timestamp,
      json["priority"] as String,
      json["subTask"] as List<dynamic>,
      json["category"] as Map<String, dynamic>,
    );
  }

  static TodoEntity fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    return TodoEntity(
      snap.data()['id'] as String,
      snap.data()['title'] as String,
      snap.data()['completed'] as bool,
      snap.data()['description'] as String,
      snap.data()['dueDate'] as Timestamp,
      snap.data()['priority'] as String,
      snap.data()['subTask'],
      snap.data()['category'],
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
    };
  }
}
