import 'package:detailed_hands_on/features/counter/presentation/bloc/counter_event.dart';
import 'package:detailed_hands_on/features/counter/presentation/bloc/counter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState.initial()) {
    on<IncrementCounter>(incrementCounter);
    on<DecrementCounter>(decrementCounter);
  }

  void incrementCounter(IncrementCounter event, Emitter<CounterState> emit) {
    final newCount = (state.count ?? 0) + 1;
    print('New count ${newCount}');
    emit(CounterState(count: newCount));
  }

  void decrementCounter(DecrementCounter event, Emitter<CounterState> emit) {
    final newCount = (state.count ?? 0) - 1;
    emit(CounterState(count: newCount));
  }
}
