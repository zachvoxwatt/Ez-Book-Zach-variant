import 'package:ez_book/src/blocs/user/info/user_info_bloc.dart';
import 'package:ez_book/src/pages/user/widgets/signin_widget.dart';
import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:ez_book/src/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/user/account/user_acc_bloc.dart';
import '../../../models/error.dart';
import 'input_field.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController unameCTRL = TextEditingController();
  final TextEditingController upassCTRL = TextEditingController();
  final TextEditingController phoneCTRL = TextEditingController();
  final TextEditingController dnameCTRL = TextEditingController();
  final SettingsController settingsController;
  final bool fromSignin;

  RegisterScreen(
      {Key? key, required this.settingsController, required this.fromSignin})
      : super(key: key);

  void returnBack(BuildContext context) async {
    await Future.delayed(const Duration(microseconds: 5));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context)
            .unfocus(), // hides the keyboard when tapping outside of the fields
        child: Scaffold(body:
            BlocBuilder<UserInfoBloc, UserInfoState>(builder: (context, state) {
          if (state is UserInfoActive) {
            returnBack(context);
            return const SizedBox.shrink();
          }
          return SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.screenHeight! * 0.1,
                      left: SizeConfig.screenWidth! * 0.1,
                      right: SizeConfig.screenWidth! * 0.1),
                  child: Column(
                    children: [
                      inputColumns(context),
                      actionButtons(context),
                      backToSignin(context),
                      BlocBuilder<UserAccountBloc, UserAccountState>(
                        builder: (context, state) {
                          if (state is UserAccountRegistryFailed) {
                            return errorLogger(context, state);
                          }

                          if (state is UserAccountRegistrySuccess) {
                            postRegister(context);
                          }

                          return const SizedBox.shrink();
                        },
                      )
                    ],
                  )));
        })));
  }

  Column inputColumns(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return Column(
      children: [
        InputField(
            textCTRL: unameCTRL,
            placeholder: tr().user_reg_username_label,
            isPassword: false,
            shouldValidate: true),
        InputField(
            textCTRL: upassCTRL,
            placeholder: tr().user_reg_password_label,
            isPassword: true,
            shouldValidate: true),
        InputField(
            textCTRL: phoneCTRL,
            placeholder: tr().user_reg_phone_label,
            isPassword: false,
            shouldValidate: false),
        InputField(
            textCTRL: dnameCTRL,
            placeholder: tr().user_reg_displayname_label,
            isPassword: false,
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
            if (state is UserAccountRegistryWaiting) {
              return const CircularProgressIndicator();
            }

            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: SizeConfig.screenWidth! * 0.375,
                      height: SizeConfig.screenHeight! * 0.05,
                      child: ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            context.read<UserAccountBloc>().add(
                                UserAccountRegistryExecuteEvent(
                                    context: context,
                                    username: unameCTRL.text.trim(),
                                    password: upassCTRL.text.trim(),
                                    phone: phoneCTRL.text.replaceAll(" ", ""),
                                    displayname: dnameCTRL.text.trim()));
                          },
                          child: Text(tr().user_reg_button,
                              style: TextStyle(
                                  fontSize: SizeConfig.fsize(0.04375),
                                  fontWeight: FontWeight.w600)))),
                  SizedBox(
                      width: SizeConfig.screenWidth! * 0.375,
                      height: SizeConfig.screenHeight! * 0.05,
                      child: OutlinedButton(
                          onPressed: () async {
                            context
                                .read<UserAccountBloc>()
                                .add(UserAccountRegistryClearErrorEvent());

                            await Future.delayed(
                                const Duration(microseconds: 500));

                            Navigator.pop(context);
                          },
                          child: Text(tr().user_reg_cancel_button,
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
        margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.025),
        child: Column(children: [
          Text(tr().user_reg_alt_signin_1,
              style: TextStyle(fontSize: SizeConfig.fsize(0.05))),
          TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth! * 0.0125,
                    right: SizeConfig.screenWidth! * 0.0125),
                minimumSize: Size.zero),
            onPressed: () {
              if (fromSignin) {
                Navigator.pop(context);
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignInScreen(
                            settingsController: settingsController,
                            fromRegister: true)));
              }
            },
            child: Text(tr().user_reg_alt_signin_2,
                style: TextStyle(fontSize: SizeConfig.fsize(0.05))),
          )
        ]));
  }

  Container errorLogger(BuildContext context, UserAccountRegistryFailed state) {
    if (state.errorCode == 0) {
      return Container(
          margin: EdgeInsets.only(
              top: SizeConfig.screenHeight! * 0.015,
              bottom: SizeConfig.screenHeight! * 0.015),
          padding: EdgeInsets.only(
              top: SizeConfig.screenHeight! * 0.005,
              bottom: SizeConfig.screenHeight! * 0.005,
              left: SizeConfig.screenWidth! * 0.025,
              right: SizeConfig.screenWidth! * 0.025),
          decoration: BoxDecoration(
              color: const Color(0xff800000),
              border: Border.all(width: 2, color: const Color(0xfff08080)),
              borderRadius: BorderRadius.circular(8)),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: state.errorLog.length,
              shrinkWrap: true,
              itemBuilder: (context, int index) {
                return Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.screenHeight! * 0.005,
                        bottom: SizeConfig.screenHeight! * 0.005),
                    child: Text('\u2022 ${state.errorLog[index]}',
                        style: const TextStyle(color: Colors.white)));
              }));
    } else {
      var callbackMsg = RegistryError.lookup(context, state.errorCode);
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
          child: Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.screenHeight! * 0.005,
                  bottom: SizeConfig.screenHeight! * 0.005),
              child: Text('\u2022 $callbackMsg',
                  style: const TextStyle(color: Colors.white))));
    }
  }

  void postRegister(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 100));
    Navigator.pop(context);
  }
}
