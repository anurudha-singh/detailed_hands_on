import 'package:detailed_hands_on/features/counter/presentation/screens/counter_screen.dart';
import 'package:detailed_hands_on/features/todo_with_filter/presentation/screens/todo_list_with_filter.dart';

dynamic routes = {
  '/': (context) => CounterScreen(),
  TodoListWithFilter.routeName: (context) => const TodoListWithFilter(),
};
