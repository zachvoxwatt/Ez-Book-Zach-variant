part of 'reminder_bloc.dart';

@immutable
abstract class ReminderEvent {}

class ReminderLoadEvent extends ReminderEvent {
  final Object requiredInfo;

  ReminderLoadEvent({required this.requiredInfo});
}

class ReminderSilentRefreshEvent extends ReminderEvent {
  final Object requiredInfo;

  ReminderSilentRefreshEvent({required this.requiredInfo});
}
