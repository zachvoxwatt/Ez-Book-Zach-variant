part of 'reminder_focus_bloc.dart';

@immutable
abstract class ReminderFocusEvent {}

class ReminderFocusSelectEvent extends ReminderFocusEvent {
  final Reminder selectedReminder;

  ReminderFocusSelectEvent({required this.selectedReminder});
}

class ReminderFocusDeselectEvent extends ReminderFocusEvent {}
