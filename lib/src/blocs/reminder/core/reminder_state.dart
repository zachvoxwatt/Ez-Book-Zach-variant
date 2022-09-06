part of 'reminder_bloc.dart';

@immutable
abstract class ReminderState {}

class ReminderInitial extends ReminderState {}

class ReminderLoading extends ReminderState {}

class ReminderErrorNoConnection extends ReminderState {}

class ReminderErrorForbidden extends ReminderState {}

class ReminderPollSuccess extends ReminderState {}

class ReminderLoaded extends ReminderState {
  final List<Reminder> reminderList;

  ReminderLoaded({required this.reminderList});
}
