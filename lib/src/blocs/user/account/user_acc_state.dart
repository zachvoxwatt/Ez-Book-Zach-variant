part of 'user_acc_bloc.dart';

@immutable
abstract class UserAccountState {}

class UserAccountInitial extends UserAccountState {}

class UserAccountSignedIn extends UserAccountState {
  final User user;

  UserAccountSignedIn({required this.user});
}

class UserAccountSignInError extends UserAccountState {
  final int errorCode;
  UserAccountSignInError({required this.errorCode});
}

class UserAccountSignInSuccess extends UserAccountState {}

class UserAccountSignInWaiting extends UserAccountState {}

class UserAccountRegistryInitial extends UserAccountState {}

class UserAccountRegistryWaiting extends UserAccountState {}

class UserAccountRegistryNoConnection extends UserAccountState {}

class UserAccountRegistrySuccess extends UserAccountState {}

class UserAccountRegistryFailed extends UserAccountState {
  final List<String> errorLog;
  final int errorCode;

  UserAccountRegistryFailed({required this.errorLog, required this.errorCode});
}

class UserAccountRegistryUpdated extends UserAccountState {
  UserAccountRegistryUpdated(
      {required username,
      required password,
      required phone,
      required displayname});
}

//class UserAccountEditUpdate extends UserAccountState {}

class UserAccountEditWorking extends UserAccountState {}

class UserAccountEditSuccess extends UserAccountState {
  final User user;
  UserAccountEditSuccess({required this.user});
}

class UserAccountEditFailed extends UserAccountState {
  final int errorCode;

  UserAccountEditFailed({required this.errorCode});
}

class UserAccountEditTypoError extends UserAccountState {}

class UserAccountEditNoConnection extends UserAccountState {}

class UserAccountEditSameInfo extends UserAccountState {}

class UserAccountEditToInitial extends UserAccountState {}
