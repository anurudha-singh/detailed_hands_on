part of 'language_bloc.dart';

class LanguageState extends Equatable {
  final String currentlocale;
  const LanguageState(this.currentlocale);

  const LanguageState.initial({String currentlocale = 'en'})
    : currentlocale = currentlocale;

  LanguageState copyWith({String? currentlocale}) {
    return LanguageState(currentlocale ?? this.currentlocale);
  }

  @override
  List<Object> get props => [currentlocale];
}
