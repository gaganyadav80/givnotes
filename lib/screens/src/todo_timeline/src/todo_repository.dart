import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'todo_model.dart';

abstract class TodosRepository {
  Future<void> addNewTodo(TodoModel todo);

  Future<void> deleteTodo(String? todo);

  Stream<List<TodoModel>> todos();

  Future<void> updateTodo(TodoModel todo);
}

class FirebaseTodosRepository implements TodosRepository {
  final CollectionReference todoCollection = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("todos");

  @override
  Future<void> addNewTodo(TodoModel todo) async {
    return await todoCollection.doc(todo.id).set(todo.toDocument());
  }

  @override
  Future<void> deleteTodo(String? id) async {
    return await todoCollection.doc(id).delete();
  }

  @override
  Stream<List<TodoModel>> todos() {
    return todoCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((DocumentSnapshot doc) => TodoModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    });
  }

  @override
  Future<void> updateTodo(TodoModel update) async {
    return await todoCollection.doc(update.id).update(update.toDocument());
  }
}
