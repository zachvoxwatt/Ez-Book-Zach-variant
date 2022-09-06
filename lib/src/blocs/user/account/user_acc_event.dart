part of 'user_acc_bloc.dart';

@immutable
abstract class UserAccountEvent {}

class UserAccountSignInEvent extends UserAccountEvent {
  final String username, password;

  UserAccountSignInEvent({required this.username, required this.password});
}

class UserAccountRegistryIdleEvent extends UserAccountEvent {}

class UserAccountRegistryUpdateEvent extends UserAccountEvent {
  final String username, password, phone, displayname;
  UserAccountRegistryUpdateEvent(
      {required this.username,
      required this.password,
      required this.phone,
      required this.displayname});
}

class UserAccountRegistryClearErrorEvent extends UserAccountEvent {}

class UserAccountRegistryExecuteEvent extends UserAccountEvent {
  final String username, password, phone, displayname;
  final BuildContext context;
  UserAccountRegistryExecuteEvent(
      {required this.username,
      required this.password,
      required this.phone,
      required this.displayname,
      required this.context});

  ValidationResult validate(
      String username, String password, String phone, String displayname) {
    List<String> returnMessages = [];

    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    if (username != '') {
      if (!Validator.checkLength(username)) {
        returnMessages.add(tr().user_reg_err_username_length);
      }

      if (!Validator.checkRegExp(username)) {
        returnMessages.add(tr().user_reg_err_username_regexp);
      }
    } else {
      returnMessages.add(tr().user_reg_err_username_nodata);
    }

    if (password != '') {
      if (!Validator.checkPassLength(password)) {
        returnMessages.add(tr().user_reg_err_password_length);
      }

      if (!Validator.checkRegExp(password)) {
        returnMessages.add(tr().user_reg_err_password_regexp);
      }
    } else {
      returnMessages.add(tr().user_reg_err_password_nodata);
    }

    if (phone != '') {
      if (!Validator.checkPhone(phone)) {
        returnMessages.add(tr().user_reg_err_phone_foulformat);
      }
    }

    if (displayname == '') {
      returnMessages.add(tr().user_reg_err_displayname_nodata);
    }

    if (returnMessages.isNotEmpty) {
      return ValidationResult(isValid: false, errorLog: returnMessages);
    } else {
      return const ValidationResult(isValid: true, errorLog: []);
    }
  }
}

class UserAccountEditUpdateEvent extends UserAccountEvent {
  final Object requiredInfo, toBeSent;

  UserAccountEditUpdateEvent(
      {required this.requiredInfo, required this.toBeSent});
}

class UserAccountEditTypoErrorEvent extends UserAccountEvent {}

class UserAccountEditNoConnectionEvent extends UserAccountEvent {}

class UserAccountEditSameInfoEvent extends UserAccountEvent {}

class UserAccountEditProgressEvent extends UserAccountEvent {}

class UserAccountDoneUpdateEvent extends UserAccountEvent {}
