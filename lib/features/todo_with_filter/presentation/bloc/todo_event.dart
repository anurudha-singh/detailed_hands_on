import 'package:detailed_hands_on/features/todo_with_filter/data/todo_model.dart';
import 'package:detailed_hands_on/features/todo_with_filter/presentation/bloc/todo_state.dart';

sealed class TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final TodoModel todo;

  AddTodoEvent(this.todo);
}

class LoadTodosEvent extends TodoEvent {
  // final TodoModel todo;

  LoadTodosEvent();
}

class RemoveTodoEvent extends TodoEvent {
  final TodoModel todo;

  RemoveTodoEvent(this.todo);
}

class ToggleTodoEvent extends TodoEvent {
  final int ID;

  ToggleTodoEvent(this.ID);
}

class FetchFilteredToDoEvent extends TodoEvent {
  final FilterType filterType;

  FetchFilteredToDoEvent(this.filterType);
}
