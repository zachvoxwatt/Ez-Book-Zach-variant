part of 'user_info_bloc.dart';

@immutable
abstract class UserInfoState {}

class UserInfoInitial extends UserInfoState {}

class UserInfoActive extends UserInfoState {
  final User user;

  UserInfoActive({required this.user});
}
