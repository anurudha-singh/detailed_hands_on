import 'package:detailed_hands_on/core/presentation/list_pagination.dart';
import 'package:detailed_hands_on/features/counter/presentation/screens/counter_screen.dart';
import 'package:detailed_hands_on/features/todo_with_filter/presentation/screens/todo_list_with_filter.dart';
import 'package:detailed_hands_on/features/posts/presentation/screens/posts_screen.dart';
import 'package:detailed_hands_on/features/posts/presentation/screens/create_post_screen.dart';
import 'package:detailed_hands_on/core/navigation/main_navigation_screen.dart';

dynamic routes = {
  '/': (context) => const MainNavigationScreen(),
  MainNavigationScreen.routeName: (context) => const MainNavigationScreen(),
  '/counter': (context) => const CounterScreen(),
  TodoListWithFilter.routeName: (context) => const TodoListWithFilter(),
  PaginationList.routeName: (context) => const PaginationList(),
  PostsScreen.routeName: (context) => const PostsScreen(),
  '/create_post': (context) => const CreatePostScreen(),
};
