import 'package:bloc/bloc.dart';
import 'package:detailed_hands_on/core/bloc/bloc/language/language_event.dart';
import 'package:equatable/equatable.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState.initial()) {
    on<LanguageEvent>((event, emit) {
      emit(state.copyWith(currentlocale: state.currentlocale));
    });
  }
}
