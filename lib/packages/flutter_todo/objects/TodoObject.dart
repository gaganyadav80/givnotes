// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:uuid/uuid.dart';

// @JsonSerializable()
// class TodoObject extends Equatable {
//   TodoObject({
//     String uuid,
//     this.category,
//     this.color,
//     this.icon,
//     this.tasks,
//   }) : this.uuid = uuid ?? Uuid().v4();

//   final String uuid;
//   final String category;
//   final int color;
//   final int icon;
//   // final Map<DateTime, List<TaskObject>> tasks;
//   final List<TaskObject> tasks;

//   int taskAmount() => tasks.length;

//   double percentComplete() {
//     if (tasks.isEmpty) {
//       return 1.0;
//     }
//     int completed = 0;
//     int amount = tasks.length;
//     tasks.forEach((element) {
//       if (element.isCompleted()) {
//         completed++;
//       }
//     });
//     // tasks.values.forEach((list) {
//     //   amount += list.length;
//     //   list.forEach((task) {
//     //     if (task.isCompleted()) {
//     //       completed++;
//     //     }
//     //   });
//     // });
//     return completed / amount;
//   }

//   @override
//   List<Object> get props => [uuid, category, color, icon, tasks];

//   factory TodoObject.fromJson(Map<String, dynamic> json) => _$TodoObjectFromJson(json);
//   Map<String, dynamic> toJson() => _$TodoObjectToJson(this);
// }

// @JsonSerializable()
// class TaskObject {
//   final DateTime date;
//   final String task;
//   bool completed;

//   TaskObject(this.task, this.date, {this.completed = false});

//   void setComplete(bool value) {
//     completed = value;
//   }

//   isCompleted() => completed;

//   factory TaskObject.fromJson(Map<String, dynamic> json) => _$TaskObjectFromJson(json);
//   Map<String, dynamic> toJson() => _$TaskObjectToJson(this);
// }
