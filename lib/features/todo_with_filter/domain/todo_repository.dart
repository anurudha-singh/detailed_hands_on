import 'package:detailed_hands_on/features/todo_with_filter/data/todo_model.dart';

abstract class TodoRepository {
  Future<void> removeTodo(TodoModel todo);

  Future<List<TodoModel>> fetchTodos();
  Future<void> addTodo(TodoModel todo);
  Future<void> updateTodo(TodoModel todo);
}
