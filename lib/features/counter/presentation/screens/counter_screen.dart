import 'dart:isolate';
import 'package:detailed_hands_on/core/bloc/bloc/language/language_bloc.dart';
import 'package:detailed_hands_on/core/bloc/bloc/language/language_event.dart';
import 'package:detailed_hands_on/core/bloc/bloc/themes_bloc.dart';
import 'package:detailed_hands_on/core/presentation/list_pagination.dart';
import 'package:detailed_hands_on/features/counter/presentation/bloc/counter_bloc.dart';
import 'package:detailed_hands_on/features/counter/presentation/bloc/counter_event.dart';
import 'package:detailed_hands_on/features/counter/presentation/bloc/counter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Top-level function for isolate entry point
void isolateEntrypointWithCommunication(SendPort sendPort) {
  // Perform some computation here
  int result = 0;
  for (int i = 0; i < 1000000; i++) {
    result += i;
  }

  // Send a message back to the main isolate
  sendPort.send('Computation complete! Result: $result');
}

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
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            ElevatedButton(
              onPressed: () async {
                ReceivePort receivePort = ReceivePort();
                await Isolate.spawn(
                  isolateEntrypointWithCommunication,
                  receivePort.sendPort,
                );

                // Listen for messages from the spawned isolate
                receivePort.listen((message) {
                  print('Message received from isolate: $message');
                  receivePort.close(); // Close the port when done
                });
              },
              child: Text('See Isolated example'),
            ),
            SizedBox(height: 20),
            Text(
              'Use the bottom navigation tabs to switch between features',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
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
