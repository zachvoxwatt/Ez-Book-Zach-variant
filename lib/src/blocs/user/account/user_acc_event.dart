part of 'user_acc_bloc.dart';

@immutable
abstract class UserAccountEvent {}

class UserAccountSignInEvent extends UserAccountEvent {
  final String username, password;

  UserAccountSignInEvent({required this.username, required this.password});
}

class UserAccountSignOutEvent extends UserAccountEvent {}

class UserAccountRegistryIdleEvent extends UserAccountEvent {}

class UserAccountRegistryUpdateEvent extends UserAccountEvent {
  final String username, password, phone, displayName;
  UserAccountRegistryUpdateEvent(
      {required this.username,
      required this.password,
      required this.phone,
      required this.displayName});
}

class UserAccountRegistryClearErrorEvent extends UserAccountEvent {}

class UserAccountRegistryExecuteEvent extends UserAccountEvent {
  final String username, password, phone, displayName;
  UserAccountRegistryExecuteEvent(
      {required this.username,
      required this.password,
      required this.phone,
      required this.displayName});

  ValidationResult validate(
      String username, String password, String phone, String displayName) {
    List<String> returnMessages = [];

    if (username != '') {
      if (!Validator.checkLength(username)) {
        returnMessages.add(
            'Username is too long or too short! It should be in between 6 - 30 characters.');
      }

      if (!Validator.checkRegExp(username)) {
        returnMessages.add(
            'Username contains prohibited special characters or spaces! It should only enclose alphanumeric characters, underscores and dots!');
      }
    } else {
      returnMessages.add('No input given in the Username field');
    }

    if (password != '') {
      if (!Validator.checkPassLength(password)) {
        returnMessages
            .add('Password is too short! It should be more than 6 characters!');
      }

      if (!Validator.checkRegExp(password)) {
        returnMessages.add(
            'Password contains prohibited special characters or spaces! It should only enclose alphanumeric characters, underscores and dots!');
      }
    } else {
      returnMessages.add('No input given in the Password field');
    }

    if (phone != '') {
      if (!Validator.checkPhone(phone)) {
        returnMessages.add(
            'Phone number does not match general form or has spaces! It should only contain digits and / or a plus (+) sign at the start!');
      }
    }

    if (displayName == '') {
      returnMessages.add('No input given in the Display Name field');
    }

    if (returnMessages.isNotEmpty) {
      return ValidationResult(isValid: false, errorLog: returnMessages);
    } else {
      return const ValidationResult(isValid: true, errorLog: []);
    }
  }
}
