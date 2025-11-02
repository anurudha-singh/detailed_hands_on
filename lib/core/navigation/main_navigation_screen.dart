import 'package:flutter/material.dart';
import '../../features/counter/presentation/screens/counter_screen.dart';
import '../../features/todo_with_filter/presentation/screens/todo_list_with_filter.dart';
import '../../features/posts/presentation/screens/posts_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  static String routeName = '/main';

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Root screens for each tab
  final List<Widget> _screens = [
    const CounterScreen(),
    const TodoListWithFilter(),
    const PostsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Todos'),
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: 'Posts'),
        ],
      ),
    );
  }
}
