part of 'reminder_creation_bloc.dart';

@immutable
abstract class ReminderCreationState {}

class ReminderCreationInitial extends ReminderCreationState {}

class ReminderCreationWaiting extends ReminderCreationState {}

class ReminderCreationErrorNoConnection extends ReminderCreationState {}

class ReminderCreationSuccess extends ReminderCreationState {}

class ReminderCreationCleared extends ReminderCreationState {}
