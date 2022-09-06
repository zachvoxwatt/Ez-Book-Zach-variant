part of 'reminder_creation_bloc.dart';

@immutable
abstract class ReminderCreationEvent {}

class ReminderCreationClearEvent extends ReminderCreationEvent {}

class ReminderCreationAddEvent extends ReminderCreationEvent {
  final Object datagram;

  ReminderCreationAddEvent({required this.datagram});
}

class ReminderCreationTransformInitialEvent extends ReminderCreationEvent {}
