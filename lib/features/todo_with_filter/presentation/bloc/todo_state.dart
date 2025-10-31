import 'package:detailed_hands_on/features/todo_with_filter/data/todo_model.dart';
import 'package:equatable/equatable.dart';

enum FilterType { all, completed, pending }

enum TodoStatus { loading, completed, error }

class TodoState extends Equatable {
  final List<TodoModel> todos;
  final List<TodoModel> filteredTodos;
  final FilterType filterType;
  final TodoStatus status;
  final bool isDone;

  const TodoState({
    required this.todos,
    required this.filteredTodos,
    required this.filterType,
    required this.status,
    required this.isDone,
  });

  factory TodoState.initial() {
    return TodoState(
      todos: [],
      filteredTodos: [],
      filterType: FilterType.all,
      status: TodoStatus.loading,
      isDone: false,
    );
  }
  TodoState copyWith({
    List<TodoModel>? todos,
    List<TodoModel>? filteredTodos,
    FilterType? filterType,
    TodoStatus? status,
    bool? isDone,
  }) {
    print(
      'Copying TodoState with todos length: ${todos?.length ?? this.todos.length}',
    );
    return TodoState(
      todos: todos ?? this.todos,
      filteredTodos: filteredTodos ?? this.filteredTodos,
      filterType: filterType ?? this.filterType,
      status: status ?? this.status,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  List<Object?> get props => [todos, filteredTodos, filterType, isDone, status];
}
