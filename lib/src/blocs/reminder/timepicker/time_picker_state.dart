part of 'time_picker_bloc.dart';

@immutable
abstract class ReminderTimePickerState {}

class ReminderTimePickerInitial extends ReminderTimePickerState {}

class ReminderTimePickerSelected extends ReminderTimePickerState {
  final String time;
  ReminderTimePickerSelected({required this.time});
}

class ReminderTimePickerCanceled extends ReminderTimePickerState {}
