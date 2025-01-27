import 'package:ez_book/src/blocs/user/info/user_info_bloc.dart';
import 'package:ez_book/src/models/error.dart';
import 'package:ez_book/src/pages/user/widgets/register_widget.dart';
import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:ez_book/src/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/user/account/user_acc_bloc.dart';
import 'input_field.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController unameCTRL = TextEditingController();
  final TextEditingController upassCTRL = TextEditingController();
  final SettingsController settingsController;
  final bool fromRegister;

  SignInScreen(
      {Key? key, required this.settingsController, required this.fromRegister})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context)
            .unfocus(), // hides the keyboard when tapping outside of the fields
        child: Scaffold(
            body: Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.screenHeight! * 0.1,
                    left: SizeConfig.screenWidth! * 0.15,
                    right: SizeConfig.screenWidth! * 0.15),
                child: Column(
                  children: [
                    inputColumns(context),
                    actionButtons(context),
                    backToSignin(context),
                    signinErrMsg(context),
                    signedInDialog(context),
                    continueDialog(context)
                  ],
                ))));
  }

  Column inputColumns(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return Column(
      children: [
        InputField(
            textCTRL: unameCTRL,
            placeholder: tr().user_signin_username_label,
            isPassword: false,
            shouldValidate: false),
        InputField(
            textCTRL: upassCTRL,
            placeholder: tr().user_signin_password_label,
            isPassword: true,
            shouldValidate: false)
      ],
    );
  }

  Container actionButtons(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return Container(
        margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.0375),
        child: BlocBuilder<UserAccountBloc, UserAccountState>(
          builder: (context, state) {
            if (state is UserAccountSignInWaiting) {
              return const CircularProgressIndicator();
            }

            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: SizeConfig.screenWidth! * 0.3375,
                      height: SizeConfig.screenHeight! * 0.05,
                      child: ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            context.read<UserAccountBloc>().add(
                                UserAccountSignInEvent(
                                    username: unameCTRL.text,
                                    password: upassCTRL.text));
                          },
                          child: Text(tr().user_signin_signin_button_label,
                              style: TextStyle(
                                  fontSize: SizeConfig.fsize(0.04375),
                                  fontWeight: FontWeight.w600)))),
                  SizedBox(
                      width: SizeConfig.screenWidth! * 0.3375,
                      height: SizeConfig.screenHeight! * 0.05,
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(tr().user_signin_back_button_label,
                              style: TextStyle(
                                  fontSize: SizeConfig.fsize(0.04375),
                                  fontWeight: FontWeight.w600))))
                ]);
          },
        ));
  }

  Container backToSignin(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return Container(
        margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.02),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(tr().user_signin_reg_alt1,
              style: TextStyle(fontSize: SizeConfig.fsize(0.05))),
          TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth! * 0.0125,
                    right: SizeConfig.screenWidth! * 0.0125),
                minimumSize: Size.zero),
            onPressed: () {
              if (fromRegister) {
                Navigator.pop(context);
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterScreen(
                            settingsController: settingsController,
                            fromSignin: true)));
              }
            },
            child: Text(tr().user_signin_reg_alt2,
                style: TextStyle(fontSize: SizeConfig.fsize(0.05))),
          )
        ]));
  }

  BlocBuilder signinErrMsg(BuildContext context) {
    return BlocBuilder<UserAccountBloc, UserAccountState>(
      builder: (context, state) {
        if (state is UserAccountSignInError) {
          return Container(
              margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.015),
              padding: EdgeInsets.only(
                  top: SizeConfig.screenHeight! * 0.005,
                  bottom: SizeConfig.screenHeight! * 0.005,
                  left: SizeConfig.screenWidth! * 0.025,
                  right: SizeConfig.screenWidth! * 0.025),
              decoration: BoxDecoration(
                  color: const Color(0xff800000),
                  border: Border.all(width: 2, color: const Color(0xfff08080)),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                SignInError.lookup(context, state.errorCode),
                style: const TextStyle(color: Colors.white),
              ));
        }
        return const SizedBox.shrink();
      },
    );
  }

  BlocBuilder signedInDialog(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return BlocBuilder<UserAccountBloc, UserAccountState>(
      builder: (context, state) {
        if (state is UserAccountRegistrySuccess) {
          return Container(
              margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.025),
              padding: EdgeInsets.only(
                  top: SizeConfig.screenHeight! * 0.005,
                  bottom: SizeConfig.screenHeight! * 0.005,
                  left: SizeConfig.screenWidth! * 0.025,
                  right: SizeConfig.screenWidth! * 0.025),
              decoration: BoxDecoration(
                  color: const Color(0xff03c04a),
                  border: Border.all(width: 2, color: const Color(0xff99edc3)),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                tr().user_reg_success,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ));
        }

        return const SizedBox.shrink();
      },
    );
  }

  BlocListener continueDialog(BuildContext context) {
    return BlocListener<UserAccountBloc, UserAccountState>(
        listener: (context, state) {
          if (state is UserAccountSignedIn) {
            context
                .read<UserInfoBloc>()
                .add(UserInfoSetEvent(user: state.user));

            Navigator.pop(context);
          }
        },
        child: const SizedBox.shrink());
  }
}
