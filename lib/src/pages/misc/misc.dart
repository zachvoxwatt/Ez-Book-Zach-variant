import 'package:ez_book/src/pages/misc/widgets/font.dart';
import 'package:ez_book/src/pages/misc/widgets/localization.dart';
import 'package:ez_book/src/pages/misc/widgets/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../settings/settings_controller.dart';
import '../../size_config.dart';

class MiscellaneousScreen extends StatelessWidget {
  const MiscellaneousScreen({Key? key, required this.settingsController})
      : super(key: key);
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return SingleChildScrollView(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
                top: SizeConfig.screenHeight! * 0.0075,
                left: SizeConfig.screenWidth! * 0.05,
                right: SizeConfig.screenWidth! * 0.05),
            child: Text(tr().tab_misc,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.screenWidth! * 0.1)),
          ),
          miscItems(context)
        ]));
  }

  Container miscItems(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: itemBottomBorderColor(),
            ),
            borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.only(
            left: SizeConfig.screenWidth! * 0.025,
            right: SizeConfig.screenWidth! * 0.025),
        margin: EdgeInsets.only(
            top: SizeConfig.screenHeight! * 0.015,
            left: SizeConfig.screenWidth! * 0.05,
            right: SizeConfig.screenWidth! * 0.05),
        child: Column(children: [
          ThemeSetting(settingsController: settingsController),
          FontSetting(
            settingsController: settingsController,
          ),
          LocalizationSetting(settingsController: settingsController)
        ]));
  }

  Color itemBottomBorderColor() {
    return settingsController.themeMode == ThemeMode.dark
        ? const Color(0xffffffff)
        : const Color(0xff000000);
  }
}
