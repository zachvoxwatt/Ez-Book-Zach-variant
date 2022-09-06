import 'package:bloc/bloc.dart';
import 'package:ez_book/src/services/repositories/ping.dart';
import 'package:ez_book/src/services/repositories/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../models/user.dart';
import '../../../models/validation_result.dart';
import 'validator.dart';

part 'user_acc_event.dart';
part 'user_acc_state.dart';

class UserAccountBloc extends Bloc<UserAccountEvent, UserAccountState> {
  final UserRepository repo;
  UserAccountBloc({required this.repo}) : super(UserAccountInitial()) {
    on<UserAccountSignInEvent>(_onSignIn);

    on<UserAccountRegistryUpdateEvent>(_onRegUpdate);
    on<UserAccountRegistryClearErrorEvent>(_onRegClearErr);
    on<UserAccountRegistryExecuteEvent>(_onRegExec);
    on<UserAccountRegistryIdleEvent>(_onRegIdle);

    on<UserAccountEditUpdateEvent>(_onEdit);
    on<UserAccountEditTypoErrorEvent>(_onErrorTypoEdit);
    on<UserAccountEditNoConnectionEvent>(_onEditNoConnection);
    on<UserAccountEditSameInfoEvent>(_onSameInfoEdit);
    on<UserAccountEditProgressEvent>(_onEditProgress);
    on<UserAccountDoneUpdateEvent>(_onAfterEdit);
  }

  void _onSignIn(
      UserAccountSignInEvent event, Emitter<UserAccountState> emit) async {
    emit(UserAccountSignInWaiting());
    var pingTest = await PingRepository.pingServer();
    await Future.delayed(const Duration(seconds: 1));

    if (!pingTest) {
      emit(UserAccountSignInError(errorCode: -1));
      return;
    }

    var datagram = {"username": event.username, "password": event.password};
    var result = await repo.signin(datagram);

    if (result is UserAccountSignInErrorModel) {
      emit(UserAccountSignInError(errorCode: result.errorCode));
      return;
    }

    emit(UserAccountSignedIn(user: result));
  }

  void _onRegUpdate(
      UserAccountRegistryUpdateEvent event, Emitter<UserAccountState> emit) {
    emit(UserAccountRegistryUpdated(
        username: event.username,
        password: event.password,
        phone: event.phone,
        displayname: event.displayname));
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

    var pingTest = await PingRepository.pingServer();

    if (!pingTest) {
      emit(UserAccountRegistryFailed(errorLog: const [], errorCode: -1));
      return;
    }

    ValidationResult result = event.validate(
        event.username, event.password, event.phone, event.displayname);

    if (result.isValid) {
      var datagram = {
        "username": event.username,
        "password": event.password,
        "phone": event.phone,
        "displayname": event.displayname
      };
      var receivedData = await repo.register(datagram);

      if (receivedData is UserAccountRegistryErrorModel) {
        emit(UserAccountRegistryFailed(
            errorCode: receivedData.errorCode, errorLog: const []));
        return;
      }

      emit(UserAccountRegistrySuccess());
      await Future.delayed(const Duration(seconds: 7));
      emit(UserAccountRegistryInitial());
    } else {
      emit(UserAccountRegistryFailed(errorCode: 0, errorLog: result.errorLog));
    }
  }

  void _onEdit(
      UserAccountEditUpdateEvent event, Emitter<UserAccountState> emit) async {
    emit(UserAccountEditWorking());
    await Future.delayed(const Duration(milliseconds: 1500));

    var response = await repo.update(event.requiredInfo, event.toBeSent);

    if (response is UserAccountEditSuccessModel) {
      emit(UserAccountEditSuccess(user: response.user));
    } else if (response is UserAccountEditFailedModel) {
      emit(UserAccountEditFailed(errorCode: response.errorCode));
    }
  }

  void _onEditProgress(UserAccountEditProgressEvent event,
      Emitter<UserAccountState> emit) async {
    emit(UserAccountEditWorking());
  }

  void _onErrorTypoEdit(UserAccountEditTypoErrorEvent event,
      Emitter<UserAccountState> emit) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    emit(UserAccountEditTypoError());
  }

  void _onSameInfoEdit(UserAccountEditSameInfoEvent event,
      Emitter<UserAccountState> emit) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    emit(UserAccountEditSameInfo());
  }

  void _onAfterEdit(
      UserAccountDoneUpdateEvent event, Emitter<UserAccountState> emit) async {
    await Future.delayed(const Duration(milliseconds: 500));
    emit(UserAccountInitial());
  }

  void _onEditNoConnection(UserAccountEditNoConnectionEvent event,
      Emitter<UserAccountState> emit) async {
    emit(UserAccountEditWorking());
    await Future.delayed(const Duration(milliseconds: 1500));
    emit(UserAccountEditFailed(errorCode: -1));
  }
}
