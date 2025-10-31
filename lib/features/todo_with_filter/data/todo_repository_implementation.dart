import 'package:detailed_hands_on/features/todo_with_filter/data/todo_database.dart';
import 'package:detailed_hands_on/features/todo_with_filter/data/todo_model.dart';
import 'package:detailed_hands_on/features/todo_with_filter/domain/todo_repository.dart';

class TodoRepositoryImplementation extends TodoRepository {
  final TodoDatabase dataSource = TodoDatabase();

  @override
  Future<void> removeTodo(TodoModel todo) {
    return dataSource.deleteTodo(todo);
  }

  @override
  Future<List<TodoModel>> fetchTodos() {
    return dataSource.getTodos();
  }

  @override
  Future<void> addTodo(TodoModel todo) {
    return dataSource.insertTodo(todo);
  }

  @override
  Future<void> updateTodo(TodoModel todo) {
    return dataSource.updateTodo(todo);
  }
}
