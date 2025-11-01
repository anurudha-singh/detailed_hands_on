import 'package:detailed_hands_on/core/bloc/bloc/language/language_bloc.dart';
import 'package:detailed_hands_on/core/bloc/bloc/themes_bloc.dart';
import 'package:detailed_hands_on/core/utils/routes.dart';
import 'package:detailed_hands_on/features/counter/presentation/bloc/counter_bloc.dart';
import 'package:detailed_hands_on/features/todo_with_filter/data/todo_database.dart';
import 'package:detailed_hands_on/features/todo_with_filter/data/todo_repository_implementation.dart';
import 'package:detailed_hands_on/features/todo_with_filter/presentation/bloc/todo_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TodoDatabase().initDB();
  print('Database initialized');
  await EasyLocalization.ensureInitialized();
  TodoRepositoryImplementation todoRepositoryImplementation =
      TodoRepositoryImplementation();
  runApp(
    EasyLocalization(
      supportedLocales: [const Locale('en', 'US'), const Locale('es', 'ES')],
      path: 'lib/assets/languages',
      child: MyApp(todoRepositoryImplementation: todoRepositoryImplementation),
    ),
  );
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

        BlocProvider(create: (BuildContext context) => CounterBloc()),
        BlocProvider(create: (BuildContext context) => ThemesBloc()),
        BlocProvider(create: (BuildContext context) => LanguageBloc()),
      ],
      child: BlocBuilder<ThemesBloc, ThemesState>(
        builder: (context, state) {
          return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, languageState) {
              return MaterialApp(
                title: 'Detailed Hands On',
                theme: state.isDark ? ThemeData.dark() : ThemeData.light(),
                // initialRoute: '/todo_list_with_filter',
                debugShowCheckedModeBanner: false,
                routes: routes,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: languageState.currentlocale == 'en'
                    ? Locale('en', 'US')
                    : Locale('es', 'ES'),
              );
            },
          );
        },
      ),
    );
  }
}
