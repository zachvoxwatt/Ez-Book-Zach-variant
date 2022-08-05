part of 'language_bloc.dart';

@immutable
abstract class LanguageState {
  final Locale locale;

  const LanguageState({required this.locale});

  List<Object> get props => [locale];
}

class LanguageInitial extends LanguageState {
  const LanguageInitial() : super(locale: const Locale('en', ''));
}

class LanguageChanged extends LanguageState {
  const LanguageChanged({required locale}) : super(locale: locale);
}
