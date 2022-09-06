part of 'user_info_bloc.dart';

@immutable
abstract class UserInfoState {}

class UserInfoInitial extends UserInfoState {}

class UserInfoActive extends UserInfoState {
  final User user;

  UserInfoActive({required this.user});
}

class UserInfoPassive extends UserInfoState {}

class UserInfoSignOutWaiting extends UserInfoState {}

class UserInfoDeleteWaiting extends UserInfoState {}

class UserInfoDeleteError extends UserInfoState {}

class UserInfoDeletePassive extends UserInfoState {}
