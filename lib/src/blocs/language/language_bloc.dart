import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageInitial()) {
    on<LanguageChangeEvent>((event, emit) {
      emit(LanguageChanged(locale: event.locale));
    });
  }
}
