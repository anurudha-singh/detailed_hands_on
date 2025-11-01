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
              child: Text('Go to Todo List With Filter'),
            ),
            SizedBox(height: 20),
            Text('Counter Screen'),
          ],
        ),
      ),
    );
  }
}
