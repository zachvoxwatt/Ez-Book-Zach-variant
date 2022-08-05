part of 'user_info_bloc.dart';

@immutable
abstract class UserInfoEvent {}

class UserInfoSetEvent extends UserInfoEvent {
  final User user;

  UserInfoSetEvent({required this.user});
}
