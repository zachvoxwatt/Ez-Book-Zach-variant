part of 'time_picker_bloc.dart';

@immutable
abstract class ReminderTimePickerEvent {}

class ReminderTimePickerSelectEvent extends ReminderTimePickerEvent {
  final String time;

  ReminderTimePickerSelectEvent({required this.time});
}

class ReminderTimePickerResetEvent extends ReminderTimePickerEvent {}

class ReminderTimePickerCancelEvent extends ReminderTimePickerEvent {}
