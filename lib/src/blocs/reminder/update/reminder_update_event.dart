part of 'reminder_update_bloc.dart';

@immutable
abstract class ReminderUpdateEvent {}

class ReminderUpdateIdleEvent extends ReminderUpdateEvent {}

class ReminderUpdateCompletionEvent extends ReminderUpdateEvent {
  final String reminderId;
  final bool isCompleted;

  ReminderUpdateCompletionEvent(
      {required this.reminderId, required this.isCompleted});
}

class ReminderUpdateInfoEvent extends ReminderUpdateEvent {
  final Object requiredInfo, datagram;
  ReminderUpdateInfoEvent({required this.requiredInfo, required this.datagram});
}

class ReminderUpdateToInitialEvent extends ReminderUpdateEvent {}

class ReminderUpdateDeleteEvent extends ReminderUpdateEvent {
  final String reminderId;

  ReminderUpdateDeleteEvent({required this.reminderId});
}
