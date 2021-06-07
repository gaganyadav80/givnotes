import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'todo_entity.dart';
import 'todo_model.dart';
import 'todo_repository.dart';

class FirebaseTodosRepository implements TodosRepository {
  final CollectionReference todoCollection = FirebaseFirestore.instance.collection(
    "${FirebaseAuth.instance.currentUser?.uid ?? 'default'}",
  );

  @override
  Future<void> addNewTodo(TodoModel todo) {
    return todoCollection
        .doc(todo.id)
        .set(todo.toEntity().toDocument())
        .then((value) => print("Todo Added"))
        .catchError((error) => print("Failed to add todo: $error"));
  }

  @override
  Future<void> deleteTodo(String id) async {
    return todoCollection.doc(id).delete();
  }

  @override
  Stream<List<TodoModel>> todos() {
    return todoCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((DocumentSnapshot doc) => TodoModel.fromEntity(TodoEntity.fromSnapshot(doc))).toList();
    });
  }

  @override
  Future<void> updateTodo(TodoModel update) {
    return todoCollection.doc(update.id).update(update.toEntity().toDocument());
  }
}
