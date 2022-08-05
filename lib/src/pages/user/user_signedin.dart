import 'package:ez_book/src/pages/user/widgets/signedin_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/user.dart';
import '../../settings/settings_controller.dart';
import '../../size_config.dart';

class UserSignedInScreen extends StatelessWidget {
  final User data;
  final SettingsController settingsController;

  const UserSignedInScreen(
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
        child: Text(data.displayName!,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.screenWidth! * 0.1)),
      ),
      Container(
          margin: EdgeInsets.only(
              top: SizeConfig.screenHeight! * 0.05,
              left: SizeConfig.screenWidth! * 0.05,
              right: SizeConfig.screenWidth! * 0.05),
          alignment: Alignment.centerLeft,
          child: Text('Your credentials information (tap for details):',
              style: TextStyle(fontSize: SizeConfig.fsize(0.045)))),
      Container(
          decoration: BoxDecoration(
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
                data: data.username!,
                label: 'Username',
                settingsController: settingsController),
            AccountSettingsCard(
                data: '*************',
                label: 'Password',
                settingsController: settingsController),
            AccountSettingsCard(
                data: data.displayName!,
                label: 'Display name',
                settingsController: settingsController),
            AccountSettingsCard(
                data: data.phone == '' ? 'None' : data.phone!,
                label: 'Phone',
                settingsController: settingsController)
          ])),
      Container(
          margin: EdgeInsets.only(
              top: SizeConfig.screenHeight! * 0.025,
              left: SizeConfig.screenWidth! * 0.05,
              right: SizeConfig.screenWidth! * 0.05),
          child: Text(
            'Session Token ID (do not share this with anyone!): ${data.sessionToken}',
            style: TextStyle(
                fontStyle: FontStyle.italic, color: const Color(0xbbffffff)),
          )),
      OutlinedButton(
          onPressed: () {},
          child: Text('Sign Out',
              style: TextStyle(
                  fontSize: SizeConfig.fsize(0.05), color: Colors.red)))
    ]);
  }
}
