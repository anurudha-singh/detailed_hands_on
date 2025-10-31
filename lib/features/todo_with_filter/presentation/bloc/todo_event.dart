import 'package:detailed_hands_on/features/todo_with_filter/data/todo_model.dart';

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
  final TodoModel todo;

  ToggleTodoEvent(this.todo);
}
