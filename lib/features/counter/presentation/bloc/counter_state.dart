import 'package:equatable/equatable.dart';

class CounterState extends Equatable {
  final int? count;

  const CounterState({this.count});

  factory CounterState.initial() => CounterState(count: 0);

  @override
  List<Object?> get props => [count];
}
