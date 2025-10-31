import 'package:detailed_hands_on/core/utils/routes.dart';
import 'package:detailed_hands_on/features/todo_with_filter/presentation/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TODOBloc>(create: (BuildContext context) => TODOBloc()),
      ],
      child: MaterialApp(
        title: 'Detailed Hands On',
        // initialRoute: '/todo_list_with_filter',
        debugShowCheckedModeBanner: false,
        routes: routes,
      ),
    );
  }
}
