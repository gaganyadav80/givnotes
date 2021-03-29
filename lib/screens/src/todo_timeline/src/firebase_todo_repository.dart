import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'todo_entity.dart';
import 'todo_model.dart';
import 'todo_repository.dart';

class FirebaseTodosRepository implements TodosRepository {
  final CollectionReference todoCollection = FirebaseFirestore.instance.collection(
    "${FirebaseAuth.instance.currentUser.displayName}_${FirebaseAuth.instance.currentUser.email}",
  );

  @override
  Future<void> addNewTodo(Todo todo) {
    return todoCollection.doc(todo.id).set(todo.toEntity().toDocument()).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    return todoCollection.doc(todo.id).delete();
  }

  @override
  Stream<List<Todo>> todos() {
    return todoCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Todo.fromEntity(TodoEntity.fromSnapshot(doc))).toList();
    });
  }

  @override
  Future<void> updateTodo(Todo update) {
    return todoCollection.doc(update.id).update(update.toEntity().toDocument());
  }
}
