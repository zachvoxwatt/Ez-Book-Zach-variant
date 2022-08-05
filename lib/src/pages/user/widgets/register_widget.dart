import 'package:ez_book/src/pages/user/widgets/signin_widget.dart';
import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:ez_book/src/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/user/account/user_acc_bloc.dart';
import 'inputfield.dart';

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context)
            .unfocus(), // hides the keyboard when tapping outside of the fields
        child: Scaffold(
            body: SingleChildScrollView(
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
                    )))));
  }

  Column inputColumns(BuildContext context) {
    return Column(
      children: [
        InputField(
            textCTRL: unameCTRL,
            placeholder: "Username",
            isPassword: false,
            shouldValidate: true),
        InputField(
            textCTRL: upassCTRL,
            placeholder: "Password",
            isPassword: true,
            shouldValidate: true),
        InputField(
            textCTRL: phoneCTRL,
            placeholder: "Phone number (OPTIONAL)",
            isPassword: false,
            shouldValidate: false),
        InputField(
            textCTRL: dnameCTRL,
            placeholder: 'Display name',
            isPassword: false,
            shouldValidate: false)
      ],
    );
  }

  Container actionButtons(BuildContext context) {
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
                                    username: unameCTRL.text.trim(),
                                    password: upassCTRL.text.trim(),
                                    phone: phoneCTRL.text.replaceAll(" ", ""),
                                    displayName: dnameCTRL.text.trim()));
                          },
                          child: Text('Register',
                              style: TextStyle(
                                  fontSize: SizeConfig.fsize(0.04375),
                                  fontWeight: FontWeight.w600)))),
                  SizedBox(
                      width: SizeConfig.screenWidth! * 0.375,
                      height: SizeConfig.screenHeight! * 0.05,
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel',
                              style: TextStyle(
                                  fontSize: SizeConfig.fsize(0.04375),
                                  fontWeight: FontWeight.w600))))
                ]);
          },
        ));
  }

  Container backToSignin(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.0125),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Got an account? Sign in',
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
            child: Text('here!',
                style: TextStyle(fontSize: SizeConfig.fsize(0.05))),
          )
        ]));
  }

  Container errorLogger(BuildContext context, UserAccountRegistryFailed state) {
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
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: state.errorLog.length,
            shrinkWrap: true,
            itemBuilder: (context, int index) {
              return Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.screenHeight! * 0.005,
                      bottom: SizeConfig.screenHeight! * 0.005),
                  child: Text('\u2022 ${state.errorLog[index]}'));
            }));
  }

  void postRegister(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);
  }
}
