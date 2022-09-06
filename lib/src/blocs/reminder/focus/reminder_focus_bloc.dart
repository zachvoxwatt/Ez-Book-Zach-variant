import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../models/reminder.dart';

part 'reminder_focus_event.dart';
part 'reminder_focus_state.dart';

class ReminderFocusBloc extends Bloc<ReminderFocusEvent, ReminderFocusState> {
  ReminderFocusBloc() : super(ReminderFocusInitial()) {
    on<ReminderFocusSelectEvent>(_onSelect);
    on<ReminderFocusDeselectEvent>(_onDeselect);
  }

  void _onSelect(
      ReminderFocusSelectEvent event, Emitter<ReminderFocusState> emit) {
    emit(ReminderFocusSelected(selectedReminder: event.selectedReminder));
  }

  void _onDeselect(
      ReminderFocusDeselectEvent event, Emitter<ReminderFocusState> emit) {
    emit(ReminderFocusInitial());
  }
}
