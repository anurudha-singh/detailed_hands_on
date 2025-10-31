import 'package:detailed_hands_on/features/todo_with_filter/presentation/screens/todo_list_with_filter.dart';
import 'package:flutter/material.dart';

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
            // SizedBox(height: MediaQuery.of(context).size.height * 0.4),
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
