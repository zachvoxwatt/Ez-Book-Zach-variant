abstract class Validator {
  static bool checkLength(String s) {
    return s.length >= 6 && s.length <= 30;
  }

  static bool checkPassLength(String s) {
    return s.length >= 6;
  }

  static bool checkRegExp(String s) {
    return RegExp(r"^[a-zA-Z0-9._]+$").hasMatch(s);
  }

  static bool checkPhone(String s) {
    var regex = RegExp(r"^\+{0,1}[0-9]+$");
    return regex.hasMatch(s);
  }

  bool validate(String value);
}

class UsernameValidator extends Validator {
  @override
  bool validate(String value) {
    if (value.length < 6 || value.length > 30) {
      return false;
    } else {
      return RegExp(r"^[a-zA-Z0-9._]+$").hasMatch(value);
    }
  }
}

class PasswordValidator extends Validator {
  @override
  bool validate(String value) {
    if (value.length < 6) {
      return false;
    } else {
      return RegExp(r"^[a-zA-Z0-9._]+$").hasMatch(value);
    }
  }
}

class PhoneValidator extends Validator {
  @override
  bool validate(String value) {
    var regex = RegExp(r"^\+{0,1}[0-9]+$");
    return regex.hasMatch(value);
  }
}

class DisplayNameValidator extends Validator {
  @override
  bool validate(String value) {
    return value.isNotEmpty;
  }
}
