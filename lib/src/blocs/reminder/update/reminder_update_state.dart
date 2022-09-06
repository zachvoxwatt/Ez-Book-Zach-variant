part of 'reminder_update_bloc.dart';

@immutable
abstract class ReminderUpdateState {}

class ReminderUpdateInitial extends ReminderUpdateState {}

class ReminderUpdateSuccess extends ReminderUpdateState {
  final bool autoRefresh;
  ReminderUpdateSuccess({required this.autoRefresh});
}

class ReminderUpdateWaiting extends ReminderUpdateState {}

class ReminderUpdateDeleteWaiting extends ReminderUpdateState {}

class ReminderUpdateDeleted extends ReminderUpdateState {}
