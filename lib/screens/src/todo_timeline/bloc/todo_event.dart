import 'package:equatable/equatable.dart';
import 'package:givnotes/screens/src/todo_timeline/src/todo_model.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodosEvent {}

class AddTodo extends TodosEvent {
  final TodoModel todo;

  const AddTodo(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'AddTodo { todo: $todo }';
}

class UpdateTodo extends TodosEvent {
  final TodoModel updatedTodo;

  const UpdateTodo(this.updatedTodo);

  @override
  List<Object> get props => [updatedTodo];

  @override
  String toString() => 'UpdateTodo { updatedTodo: $updatedTodo }';
}

class DeleteTodo extends TodosEvent {
  final String id;

  const DeleteTodo(this.id);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'DeleteTodo { todo_id: $id }';
}

class ClearCompleted extends TodosEvent {}

class ToggleAll extends TodosEvent {}

class TodosUpdated extends TodosEvent {
  final List<TodoModel> todos;

  const TodosUpdated(this.todos);

  @override
  List<Object> get props => [todos];
}
