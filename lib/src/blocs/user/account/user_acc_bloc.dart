import 'package:bloc/bloc.dart';
import 'package:ez_book/src/services/repositories/user.dart';
import 'package:meta/meta.dart';

import '../../../models/user.dart';
import '../../../models/validation_result.dart';
import 'validator.dart';

part 'user_acc_event.dart';
part 'user_acc_state.dart';

class UserAccountBloc extends Bloc<UserAccountEvent, UserAccountState> {
  final UserRepository repo;
  UserAccountBloc({required this.repo}) : super(UserAccountInitial()) {
    on<UserAccountSignInEvent>(_onSignIn);
    on<UserAccountSignOutEvent>(_onSignOut);
    on<UserAccountRegistryUpdateEvent>(_onRegUpdate);
    on<UserAccountRegistryClearErrorEvent>(_onRegClearErr);
    on<UserAccountRegistryExecuteEvent>(_onRegExec);
    on<UserAccountRegistryIdleEvent>(_onRegIdle);
  }

  void _onSignIn(
      UserAccountSignInEvent event, Emitter<UserAccountState> emit) async {
    emit(UserAccountSignInWaiting());

    await Future.delayed(const Duration(seconds: 1));

    var datagram = {"username": event.username, "password": event.password};
    var result = await repo.signin(datagram);

    if (result is UserAccountSignInErrorModel) {
      emit(UserAccountSignInError(errorMessage: result.errorMessage));
      return;
    }

    emit(UserAccountSignedIn(user: result));
  }

  void _onSignOut(
      UserAccountSignOutEvent event, Emitter<UserAccountState> emit) {
    emit(UserAccountSignedOut());
  }

  void _onRegUpdate(
      UserAccountRegistryUpdateEvent event, Emitter<UserAccountState> emit) {
    emit(UserAccountRegistryUpdated(
        username: event.username,
        password: event.password,
        phone: event.phone,
        displayName: event.displayName));
  }

  void _onRegIdle(
      UserAccountRegistryIdleEvent event, Emitter<UserAccountState> emit) {
    emit(UserAccountRegistryInitial());
  }

  void _onRegClearErr(UserAccountRegistryClearErrorEvent event,
      Emitter<UserAccountState> emit) async {
    await Future.delayed(const Duration(milliseconds: 10));
    emit(UserAccountRegistryInitial());
  }

  void _onRegExec(UserAccountRegistryExecuteEvent event,
      Emitter<UserAccountState> emit) async {
    emit(UserAccountRegistryWaiting());
    await Future.delayed(const Duration(seconds: 1));

    ValidationResult result = event.validate(
        event.username, event.password, event.phone, event.displayName);

    if (result.isValid) {
      var datagram = {
        "username": event.username,
        "password": event.password,
        "phone": event.phone,
        "displayName": event.displayName
      };
      await Future.delayed(const Duration(seconds: 1));
      var receivedData = await repo.register(datagram);

      if (receivedData is UserAccountRegistryErrorModel) {
        var err = [receivedData.error];
        emit(UserAccountRegistryFailed(errorLog: err));
        return;
      }

      emit(UserAccountRegistrySuccess());
    } else {
      emit(UserAccountRegistryFailed(errorLog: result.errorLog));
    }
  }
}
