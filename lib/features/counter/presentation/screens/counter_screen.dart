import 'package:detailed_hands_on/core/bloc/bloc/language/language_bloc.dart';
import 'package:detailed_hands_on/core/bloc/bloc/language/language_event.dart';
import 'package:detailed_hands_on/core/bloc/bloc/themes_bloc.dart';
import 'package:detailed_hands_on/core/presentation/list_pagination.dart';
import 'package:detailed_hands_on/features/counter/presentation/bloc/counter_bloc.dart';
import 'package:detailed_hands_on/features/counter/presentation/bloc/counter_event.dart';
import 'package:detailed_hands_on/features/counter/presentation/bloc/counter_state.dart';
import 'package:detailed_hands_on/features/todo_with_filter/presentation/screens/todo_list_with_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});
  static String routeName = '/';

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
        backgroundColor: Colors.blueAccent,
        actions: [
          BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  print('changing language to ${state.currentlocale}');
                  context.read<LanguageBloc>().add(
                    ChangeLanguage(state.currentlocale == 'en' ? 'es' : 'en'),
                  );
                },
                child: Icon(Icons.language),
              );
            },
          ),

          BlocBuilder<ThemesBloc, ThemesState>(
            builder: (context, state) => Switch(
              value: state.isDark,
              onChanged: (value) {
                context.read<ThemesBloc>().add(ToggleTheme());
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current counter value is'),
            SizedBox(height: 30),
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                return Text('${state.count}');
              },
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(IncrementCounter());
                  },
                  child: Text('Increment'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(DecrementCounter());
                  },
                  child: Text('Decrement'),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, TodoListWithFilter.routeName);
              },
              child: Text('go_to_todo_list'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/posts');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: const Text(
                'Go to Posts (Offline-First)',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, PaginationList.routeName);
              },
              child: Text('See pagination infinite list'),
            ),
          ],
        ),
      ),
    );
  }
}
