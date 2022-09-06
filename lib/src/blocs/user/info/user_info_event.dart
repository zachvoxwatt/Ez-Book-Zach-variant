part of 'user_info_bloc.dart';

@immutable
abstract class UserInfoEvent {}

class UserInfoSetEvent extends UserInfoEvent {
  final User user;

  UserInfoSetEvent({required this.user});
}

class UserInfoTransformInitial extends UserInfoEvent {}

class UserInfoSignOutEvent extends UserInfoEvent {
  final Object requiredInfo;

  UserInfoSignOutEvent({required this.requiredInfo});
}

class UserInfoDeleteEvent extends UserInfoEvent {
  final Object requiredInfo;

  UserInfoDeleteEvent({required this.requiredInfo});
}
