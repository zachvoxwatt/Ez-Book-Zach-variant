part of 'reminder_focus_bloc.dart';

@immutable
abstract class ReminderFocusState {}

class ReminderFocusInitial extends ReminderFocusState {}

class ReminderFocusSelected extends ReminderFocusState {
  final Reminder selectedReminder;

  ReminderFocusSelected({required this.selectedReminder});
}
