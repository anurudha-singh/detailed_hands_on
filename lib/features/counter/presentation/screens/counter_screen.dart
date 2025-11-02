import 'dart:async';
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

// Debouncer class implementation
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

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
  List<String> items = ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry'];
  List<String> suggestions = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  // Initialize debouncer with 300ms delay
  late final Debouncer _debouncer = Debouncer(milliseconds: 300);

  void suggestKeywords(String query) {
    if (query.isEmpty) {
      suggestions = [];
      isSearching = false;
      setState(() {});
      return;
    }

    suggestions = items
        .where(
          (item) =>
              item.toLowerCase().startsWith(query.toLowerCase()) ||
              item.contains(query.toLowerCase()),
        )
        .toList();
    isSearching = false;
    setState(() {});
    print('Suggestions for "$query": $suggestions (optimized with debouncer)');
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      setState(() {
        isSearching = true;
      });
    }

    // Use debouncer to delay the search operation
    _debouncer.run(() {
      suggestKeywords(query);
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    labelText: 'Enter a fruit',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),

                // Search suggestions with loading indicator
                if (searchController.text.isNotEmpty)
                  Container(
                    height: 200,
                    child: isSearching
                        ? Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : suggestions.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: suggestions.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(suggestions[index]),
                                leading: Icon(Icons.apple),
                                onTap: () {
                                  searchController.text = suggestions[index];
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'No fruits found',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                  ),

                SizedBox(height: 20),
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
        ),
      ),
    );
  }
}
