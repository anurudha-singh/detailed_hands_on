import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/posts/data/posts_repository.dart';
import 'features/posts/presentation/bloc/posts_bloc.dart';
import 'features/posts/presentation/screens/posts_screen.dart';

void main() {
  runApp(const MyPostsApp());
}

class MyPostsApp extends StatelessWidget {
  const MyPostsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsBloc(postsRepository: PostsRepository()),
      child: MaterialApp(
        title: 'Offline-First Posts Demo',
        theme: ThemeData(primarySwatch: Colors.purple),
        home: const PostsScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
