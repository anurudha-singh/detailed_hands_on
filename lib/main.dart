import 'package:detailed_hands_on/core/utils/routes.dart';
import 'package:detailed_hands_on/features/todo_with_filter/data/todo_database.dart';
import 'package:detailed_hands_on/features/todo_with_filter/data/todo_repository_implementation.dart';
import 'package:detailed_hands_on/features/todo_with_filter/presentation/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TodoDatabase().initDB();
  print('Database initialized');
  TodoRepositoryImplementation todoRepositoryImplementation =
      TodoRepositoryImplementation();
  runApp(MyApp(todoRepositoryImplementation: todoRepositoryImplementation));
}

class MyApp extends StatelessWidget {
  final TodoRepositoryImplementation todoRepositoryImplementation;

  const MyApp({super.key, required this.todoRepositoryImplementation});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TODOBloc>(
          create: (BuildContext context) => TODOBloc(
            todoRepositoryImplementation: todoRepositoryImplementation,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Detailed Hands On',
        // initialRoute: '/todo_list_with_filter',
        debugShowCheckedModeBanner: false,
        routes: routes,
      ),
    );
  }
}
