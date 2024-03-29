import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:givnotes/screens/src/todo_timeline/src/todo_repository.dart';

import 'todo_event.dart';
import 'todo_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosRepository _todosRepository;
  StreamSubscription? _todosSubscription;

  TodosBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(TodosLoading());

  @override
  Stream<TodosState> mapEventToState(TodosEvent event) async* {
    try {
      if (event is LoadTodos) {
        yield* _mapLoadTodosToState();
      } else if (event is AddTodo) {
        yield* _mapAddTodoToState(event);
      } else if (event is UpdateTodo) {
        yield* _mapUpdateTodoToState(event);
      } else if (event is DeleteTodo) {
        yield* _mapDeleteTodoToState(event);
      } else if (event is TodosUpdated) {
        yield* _mapTodosUpdateToState(event);
      }
      // else if (event is ToggleAll) {
      //   yield* _mapToggleAllToState();
      // } else if (event is ClearCompleted) {
      //   yield* _mapClearCompletedToState();
      // }
    } on FirebaseException catch (e) {
      yield TodosNotLoaded("Error: ${e.code.toUpperCase()}");
    }
  }

  Stream<TodosState> _mapLoadTodosToState() async* {
    yield TodosLoading();
    _todosSubscription?.cancel();
    _todosSubscription = _todosRepository.todos().listen(
          (todos) => add(TodosUpdated(todos)),
        );
  }

  Stream<TodosState> _mapAddTodoToState(AddTodo event) async* {
    _todosRepository.addNewTodo(event.todo);
  }

  Stream<TodosState> _mapUpdateTodoToState(UpdateTodo event) async* {
    _todosRepository.updateTodo(event.updatedTodo);
  }

  Stream<TodosState> _mapDeleteTodoToState(DeleteTodo event) async* {
    _todosRepository.deleteTodo(event.id);
  }

  Stream<TodosState> _mapTodosUpdateToState(TodosUpdated event) async* {
    yield TodosLoaded(event.todos);
  }

  @override
  Future<void> close() {
    _todosSubscription?.cancel();
    return super.close();
  }

  // Stream<TodosState> _mapToggleAllToState() async* {
  //   final currentState = state;
  //   if (currentState is TodosLoaded) {
  //     final allComplete = currentState.todos.every((todo) => todo.completed);
  //     final List<Todo> updatedTodos = currentState.todos.map((todo) => todo.copyWith(completed: !allComplete)).toList();
  //     updatedTodos.forEach((updatedTodo) {
  //       _todosRepository.updateTodo(updatedTodo);
  //     });
  //   }
  // }

  // Stream<TodosState> _mapClearCompletedToState() async* {
  //   final currentState = state;
  //   if (currentState is TodosLoaded) {
  //     final List<Todo> completedTodos = currentState.todos.where((todo) => todo.completed).toList();
  //     completedTodos.forEach((completedTodo) {
  //       _todosRepository.deleteTodo(completedTodo);
  //     });
  //   }
  // }
}
