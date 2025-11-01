part of 'themes_bloc.dart';

class ThemesState extends Equatable {
  final bool isDark;
  const ThemesState(this.isDark);

  ThemesState copyWith(bool? isDark) {
    return ThemesState(isDark ?? this.isDark);
  }

  const ThemesState.initial() : isDark = true;

  @override
  List<Object> get props => [isDark];
}
