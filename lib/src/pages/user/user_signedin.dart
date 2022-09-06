import 'package:ez_book/src/blocs/user/account/validator.dart';
import 'package:ez_book/src/pages/user/widgets/signedin_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../blocs/user/info/user_info_bloc.dart';
import '../../models/user.dart';
import '../../settings/settings_controller.dart';
import '../../size_config.dart';

class UserSignedInScreen extends StatelessWidget {
  final User data;
  final SettingsController settingsController;

  UserSignedInScreen(
      {Key? k, required this.data, required this.settingsController})
      : super(key: k);

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return Column(children: [
      Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(
            top: SizeConfig.screenHeight! * 0.0075,
            left: SizeConfig.screenWidth! * 0.05,
            right: SizeConfig.screenWidth! * 0.05),
        child: SizedBox(
            height: SizeConfig.screenHeight! * 0.055,
            child: Marquee(
              text: data.displayname!,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: SizeConfig.fsize(0.1)),
              scrollAxis: Axis.horizontal, //scroll direction
              crossAxisAlignment: CrossAxisAlignment.start,

              velocity: 75.0, //speed
              startAfter: const Duration(seconds: 5),
              pauseAfterRound: const Duration(seconds: 5),
              blankSpace: SizeConfig.screenWidth!,
              accelerationDuration: const Duration(seconds: 1),
              accelerationCurve: Curves.easeIn,
              decelerationDuration: const Duration(seconds: 1),
              decelerationCurve: Curves.easeOut,
            )),
      ),
      Container(
          margin: EdgeInsets.only(
              top: SizeConfig.screenHeight! * 0.05,
              left: SizeConfig.screenWidth! * 0.05,
              right: SizeConfig.screenWidth! * 0.05),
          alignment: Alignment.centerLeft,
          child: Text(tr().user_signedin_info_label,
              style: TextStyle(fontSize: SizeConfig.fsize(0.045)))),
      Container(
          decoration: BoxDecoration(
              color: settingsController.themeMode == ThemeMode.light
                  ? const Color(0x22000000)
                  : const Color(0x00ffffff),
              border: Border.all(
                  width: 2,
                  color: settingsController.themeMode == ThemeMode.dark
                      ? const Color(0xffffffff)
                      : const Color(0xff000000)),
              borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.all(SizeConfig.scaleEvenly(0.0000375)),
          margin: EdgeInsets.only(
              top: SizeConfig.screenHeight! * 0.0075,
              left: SizeConfig.screenWidth! * 0.05,
              right: SizeConfig.screenWidth! * 0.05),
          alignment: Alignment.centerLeft,
          child: Wrap(children: [
            AccountSettingsCard(
                validator: UsernameValidator(),
                property: 'username',
                data: data.username!,
                label: tr().user_signedin_username_label,
                settingsController: settingsController),
            AccountSettingsCard(
                validator: PasswordValidator(),
                property: 'password',
                data: '*************',
                label: tr().user_signedin_password_label,
                settingsController: settingsController),
            AccountSettingsCard(
                validator: DisplayNameValidator(),
                property: 'displayname',
                data: data.displayname!,
                label: tr().user_signedin_displayname_label,
                settingsController: settingsController),
            AccountSettingsCard(
                validator: PhoneValidator(),
                property: 'phone',
                data: data.phone == '' ? 'N/A' : data.phone!,
                label: tr().user_signedin_phone_label,
                settingsController: settingsController)
          ])),
      Container(
          margin: EdgeInsets.only(
              top: SizeConfig.screenHeight! * 0.025,
              left: SizeConfig.screenWidth! * 0.05,
              right: SizeConfig.screenWidth! * 0.05),
          child: Text(
            '${tr().user_signedin_token_tip} ${data.sessionToken}',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: settingsController.themeMode == ThemeMode.dark
                  ? const Color(0x66ffffff)
                  : const Color(0xff000000),
            ),
          )),
      Container(
          margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.025),
          child: SizedBox(
              width: SizeConfig.screenWidth! * 0.5,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          width: 1,
                          color: settingsController.themeMode == ThemeMode.dark
                              ? const Color(0XCCFFFFFF)
                              : const Color(0XFF000000))),
                  onPressed: () {
                    var token =
                        (context.read<UserInfoBloc>().state as UserInfoActive)
                            .user
                            .sessionToken;
                    context.read<UserInfoBloc>().add(UserInfoSignOutEvent(
                        requiredInfo: {'sessionToken': token}));
                  },
                  child: Text(tr().user_signout_button,
                      style: TextStyle(
                          fontSize: SizeConfig.fsize(0.05),
                          color: const Color(0xFFCE2029)))))),
      Container(
          margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.01),
          child: SizedBox(
              width: SizeConfig.screenWidth! * 0.5,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xffCE2029)),
                  onPressed: () async => confirmDeleteDialog(context),
                  child: Text(tr().user_signedin_delete_option,
                      style: TextStyle(
                          fontSize: SizeConfig.fsize(0.05),
                          color: Colors.white)))))
    ]);
  }

  void confirmDeleteDialog(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(tr().user_signedin_delete_dialog_label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.01),
                  child: Text(tr().user_signedin_delete_dialog_warn1)),
              Text(tr().user_signedin_delete_dialog_warn2,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFFCE2029))),
              Container(
                margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: SizeConfig.screenWidth! * 0.25,
                        child: ElevatedButton(
                            onPressed: () {
                              var activeState = context
                                  .read<UserInfoBloc>()
                                  .state as UserInfoActive;

                              var tbs = {
                                'objectId': activeState.user.objectId,
                                'sessionToken': activeState.user.sessionToken
                              };

                              context
                                  .read<UserInfoBloc>()
                                  .add(UserInfoDeleteEvent(requiredInfo: tbs));

                              Navigator.pop(context);
                            },
                            child: Text(tr().user_signedin_delete_button1_label,
                                style: TextStyle(
                                    color: const Color(0XCCFFFFFF),
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        SizeConfig.screenWidth! * 0.045)))),
                    SizedBox(
                        width: SizeConfig.screenWidth! * 0.25,
                        child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(tr().user_signedin_delete_button2_label,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        SizeConfig.screenWidth! * 0.045))))
                  ],
                ),
              ),
              BlocBuilder<UserInfoBloc, UserInfoState>(
                builder: (context, state) {
                  if (state is UserInfoDeleteError) {
                    return errorDeleteMsg(context);
                  }

                  return const SizedBox.shrink();
                },
              )
            ]),
          );
        });
  }

  Container errorDeleteMsg(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return Container(
        margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.015),
        padding: EdgeInsets.fromLTRB(
            SizeConfig.screenWidth! * 0.025,
            SizeConfig.screenHeight! * 0.0075,
            SizeConfig.screenWidth! * 0.025,
            SizeConfig.screenHeight! * 0.0075),
        decoration: errorDialogStylings,
        child: Text(
          tr().user_signedin_delete_err,
          style: TextStyle(
              color: Colors.white, fontSize: SizeConfig.fsize(0.0375)),
        ));
  }

  final errorDialogStylings = BoxDecoration(
      color: const Color(0xff800000),
      border: Border.all(width: 2, color: const Color(0xfff08080)),
      borderRadius: BorderRadius.circular(8));
}
