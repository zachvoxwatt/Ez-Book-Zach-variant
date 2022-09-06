import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistryError {
  static lookup(BuildContext context, int code) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    var errList = {
      "-1": tr().user_reg_err_neg1,
      "200": tr().user_reg_err_200,
      "201": tr().user_reg_err_201,
      "202": tr().user_reg_err_202
    };
    return errList[code.toString()];
  }
}

class SignInError {
  static lookup(BuildContext context, int code) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    var errList = {
      "-1": tr().user_reg_err_neg1,
      "101": tr().user_signin_err_101,
      "200": tr().user_signin_err_200,
      "201": tr().user_signin_err_201
    };
    return errList[code.toString()];
  }
}

class UpdateError {
  static lookup(BuildContext context, int code) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    var errList = {
      "-1": tr().user_update_err_neg1,
      "202": tr().user_update_err_202
    };
    return errList[code.toString()];
  }
}
