import 'dart:async';
import 'todo_model.dart';

abstract class TodosRepository {
  Future<void> addNewTodo(TodoModel todo);

  Future<void> deleteTodo(String todo);

  Stream<List<TodoModel>> todos();

  Future<void> updateTodo(TodoModel todo);
}
