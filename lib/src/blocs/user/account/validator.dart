class Validator {
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
}
