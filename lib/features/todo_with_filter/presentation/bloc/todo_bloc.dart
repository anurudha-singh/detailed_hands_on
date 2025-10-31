import 'package:bloc/bloc.dart';
import 'package:detailed_hands_on/features/todo_with_filter/data/todo_model.dart';
import 'package:detailed_hands_on/features/todo_with_filter/presentation/bloc/todo_event.dart';
import 'package:detailed_hands_on/features/todo_with_filter/presentation/bloc/todo_state.dart';

class TODOBloc extends Bloc<TodoEvent, TodoState> {
  TODOBloc() : super(TodoState.initial()) {
    on<AddTodoEvent>(_addTodoEvent);
    on<RemoveTodoEvent>(_removeTodoEvent);
    on<ToggleTodoEvent>(_toggleTodoEvent);
    on<LoadTodosEvent>(_loadTodosEvent);
    add(LoadTodosEvent());
  }
  void _loadTodosEvent(LoadTodosEvent event, Emitter<TodoState> emit) {
    emit(
      state.copyWith(
        todos: List.from(state.todos)..add(TodoModel(title: 'Initial Todo')),
        filteredTodos: List.from(state.filteredTodos)
          ..add(TodoModel(title: 'Initial Todo')),
        status: TodoStatus.completed,
      ),
    );
    print('New length of todos: ${state.todos.length}');
  }

  void _addTodoEvent(AddTodoEvent event, Emitter<TodoState> emit) {
    print('Adding todo: ${event.todo}');
    emit(
      state.copyWith(
        todos: List.from(state.todos)..add(event.todo),
        filteredTodos: List.from(state.filteredTodos)..add(event.todo),
        status: TodoStatus.completed,
      ),
    );
    print('New length of todos: ${state.todos.length}');
  }

  void _removeTodoEvent(RemoveTodoEvent event, Emitter<TodoState> emit) {
    emit(
      state.copyWith(
        todos: state.todos.where((todo) => todo.title != event.todo).toList(),
        filteredTodos: state.filteredTodos
            .where((todo) => todo.title != event.todo)
            .toList(),
        status: TodoStatus.completed,
      ),
    );
    print('New length of todos: ${state.todos.length}');
  }

  void _toggleTodoEvent(ToggleTodoEvent event, Emitter<TodoState> emit) {
    emit(
      state.copyWith(
        todos: state.todos.map((todo) {
          if (todo == event.todo) {
            return TodoModel(title: todo.title, isDone: !todo.isDone);
          }
          return todo;
        }).toList(),
        filteredTodos: state.filteredTodos.map((todo) {
          if (todo == event.todo) {
            return TodoModel(title: todo.title, isDone: !todo.isDone);
          }
          return todo;
        }).toList(),
      ),
    );
  }
}
