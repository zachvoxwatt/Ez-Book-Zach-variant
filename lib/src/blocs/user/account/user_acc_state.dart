part of 'user_acc_bloc.dart';

@immutable
abstract class UserAccountState {}

class UserAccountInitial extends UserAccountState {}

class UserAccountSignedOut extends UserAccountState {}

class UserAccountSignedIn extends UserAccountState {
  final User user;

  UserAccountSignedIn({required this.user});
}

class UserAccountSignInError extends UserAccountState {
  final String errorMessage;
  UserAccountSignInError({required this.errorMessage});
}

class UserAccountSignInSuccess extends UserAccountState {}

class UserAccountSignInWaiting extends UserAccountState {}

class UserAccountRegistryInitial extends UserAccountState {}

class UserAccountRegistryWaiting extends UserAccountState {}

class UserAccountRegistrySuccess extends UserAccountState {}

class UserAccountRegistryFailed extends UserAccountState {
  final List<String> errorLog;

  UserAccountRegistryFailed({required this.errorLog});
}

class UserAccountRegistryUpdated extends UserAccountState {
  UserAccountRegistryUpdated(
      {required username,
      required password,
      required phone,
      required displayName});
}
