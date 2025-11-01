import 'package:bloc/bloc.dart';
import 'package:detailed_hands_on/features/todo_with_filter/data/todo_model.dart';
import 'package:detailed_hands_on/features/todo_with_filter/data/todo_repository_implementation.dart';
import 'package:detailed_hands_on/features/todo_with_filter/presentation/bloc/todo_event.dart';
import 'package:detailed_hands_on/features/todo_with_filter/presentation/bloc/todo_state.dart';

class TODOBloc extends Bloc<TodoEvent, TodoState> {
  TodoRepositoryImplementation todoRepositoryImplementation;
  TODOBloc({required this.todoRepositoryImplementation})
    : super(TodoState.initial()) {
    on<AddTodoEvent>(_addTodoEvent);
    on<RemoveTodoEvent>(_removeTodoEvent);
    on<ToggleTodoEvent>(_toggleTodoEvent);
    on<LoadTodosEvent>(_loadTodosEvent);
    on<FetchFilteredToDoEvent>(_fetchFilteredToDo);
    add(LoadTodosEvent());
  }

  void _fetchFilteredToDo(
    FetchFilteredToDoEvent event,
    Emitter<TodoState> emit,
  ) async {
    print('Filtering todos with filter type: ${event.filterType}');
    List<TodoModel> todos = await todoRepositoryImplementation.fetchTodos();
    final filteredTodos = todos.where((todo) {
      switch (event.filterType) {
        case FilterType.all:
          return true;
        case FilterType.completed:
          return todo.isDone;
        case FilterType.pending:
          return !todo.isDone;
      }
    }).toList();

    emit(state.copyWith(todos: filteredTodos));
  }

  void _loadTodosEvent(LoadTodosEvent event, Emitter<TodoState> emit) async {
    List<TodoModel> todos = await todoRepositoryImplementation.fetchTodos();
    emit(
      state.copyWith(
        todos: todos,
        filteredTodos: todos,
        status: TodoStatus.completed,
      ),
    );
    print('New length of todos: ${state.todos.length}');
  }

  void _addTodoEvent(AddTodoEvent event, Emitter<TodoState> emit) async {
    print('Adding todo: ${event.todo.toMap()}');

    // Immediately update the state by adding the todo to both lists
    final updatedTodos = [...state.todos, event.todo];
    final updatedFilteredTodos = [...state.filteredTodos, event.todo];

    emit(
      state.copyWith(
        todos: updatedTodos,
        filteredTodos: updatedFilteredTodos,
        status: TodoStatus.completed,
      ),
    );

    // Persist to database in the background (no await to avoid blocking UI)
    todoRepositoryImplementation.addTodo(event.todo);

    print('New length of todos: ${state.todos.length}');
  }

  void _removeTodoEvent(RemoveTodoEvent event, Emitter<TodoState> emit) async {
    print('Removing todo: ${event.todo.createdAt}');

    // Immediately update the state by removing the todo from both lists
    final updatedTodos = state.todos
        .where((todo) => todo.id != event.todo.id)
        .toList();
    final updatedFilteredTodos = state.filteredTodos
        .where((todo) => todo.id != event.todo.id)
        .toList();

    emit(
      state.copyWith(
        todos: updatedTodos,
        filteredTodos: updatedFilteredTodos,
        status: TodoStatus.completed,
      ),
    );

    // Persist to database in the background (no await to avoid blocking UI)
    todoRepositoryImplementation.removeTodo(event.todo);

    print('New length of todos delete: ${state.todos.length}');
  }

  void _toggleTodoEvent(ToggleTodoEvent event, Emitter<TodoState> emit) async {
    print('Toggling todo ID: ${event.ID}');

    final updatedList = state.todos.map((todo) {
      if (todo.id == event.ID) {
        return TodoModel(
          id: todo.id,
          title: todo.title,
          isDone: !todo.isDone,
          createdAt: todo.createdAt,
        );
      }
      return todo;
    }).toList();

    emit(state.copyWith(todos: updatedList, filteredTodos: updatedList));

    print('calling updateTodo from repository');
    // Persist to database in the background (no await to avoid blocking UI and no reload)
    todoRepositoryImplementation.updateTodo(event.ID);
  }
}
