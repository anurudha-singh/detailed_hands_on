// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'themes_event.dart';
part 'themes_state.dart';

class ThemesBloc extends Bloc<ThemesEvent, ThemesState> {
  ThemesBloc() : super(ThemesState.initial()) {
    on<ToggleTheme>((event, emit) {
      emit(state.copyWith(!state.isDark));
    });
  }
}
