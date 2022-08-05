part of 'language_bloc.dart';

@immutable
abstract class LanguageEvent {}

class LanguageChangeEvent extends LanguageEvent {
  final Locale locale;
  LanguageChangeEvent({required this.locale});
}
