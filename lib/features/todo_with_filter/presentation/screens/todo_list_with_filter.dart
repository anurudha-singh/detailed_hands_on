import 'package:detailed_hands_on/features/todo_with_filter/data/todo_model.dart';
import 'package:detailed_hands_on/features/todo_with_filter/presentation/bloc/todo_bloc.dart';
import 'package:detailed_hands_on/features/todo_with_filter/presentation/bloc/todo_event.dart';
import 'package:detailed_hands_on/features/todo_with_filter/presentation/bloc/todo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoListWithFilter extends StatefulWidget {
  const TodoListWithFilter({super.key});
  static String routeName = '/todo_list_with_filter';

  @override
  State<TodoListWithFilter> createState() => _TodoListWithFilterState();
}

class _TodoListWithFilterState extends State<TodoListWithFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List With Filter'),
        backgroundColor: Colors.green,
      ),
      body: BlocBuilder<TODOBloc, TodoState>(
        builder: (context, state) {
          print('Current length of todos: ${state.todos.length}');
          return Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text('This is the Todo List With Filter Screen'),

                SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListView.builder(
                    // shrinkWrap: true,
                    itemCount: state.todos.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(
                          '${state.todos[index].title}_${state.todos[index].createdAt}',
                        ),
                        direction:
                            DismissDirection.endToStart, // 👉 Right to Left
                        background: Container(
                          color: Colors.redAccent,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          final todoToDelete = state.todos[index];
                          context.read<TODOBloc>().add(
                            RemoveTodoEvent(todoToDelete),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Deleted "${todoToDelete.title}"'),
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(
                              state.todos[index].title,
                              style: TextStyle(
                                decoration: state.todos[index].isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: Text(
                              'Created at: ${state.todos[index].createdAt}',
                            ),
                            trailing: Checkbox(
                              value: state.todos[index].isDone,
                              onChanged: (value) {
                                print(
                                  'Toggling todo ID: ${state.todos[index].id}',
                                );
                                final id = state.todos[index].id;
                                context.read<TODOBloc>().add(
                                  ToggleTodoEvent(id ?? -1),
                                );
                                // context.read<TODOBloc>().add(
                                //   ToggleTodoEvent(state.filteredTodos[index]),
                                // );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Add Todo'),
                          content: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter todo title',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<TODOBloc>().add(
                                  AddTodoEvent(
                                    TodoModel(title: 'New Todo Item'),
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              child: Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Add Todo'),
                ),
                SizedBox(height: 20),

                Wrap(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<TODOBloc>().add(
                          FetchFilteredToDoEvent(FilterType.all),
                        );
                      },
                      child: Text('Apply all filter'),
                    ),
                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        context.read<TODOBloc>().add(
                          FetchFilteredToDoEvent(FilterType.pending),
                        );
                      },
                      child: Text('Apply pending filter'),
                    ),
                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        context.read<TODOBloc>().add(
                          FetchFilteredToDoEvent(FilterType.completed),
                        );
                      },
                      child: Text('Apply completed filter'),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back to Counter Screen'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
