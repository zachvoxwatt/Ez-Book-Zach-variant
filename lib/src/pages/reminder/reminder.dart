import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../settings/settings_controller.dart';
import '../../size_config.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({Key? key, required this.settingsController})
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
            child: Text(tr().tab_reminder,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.screenWidth! * 0.1)),
          )
        ]));
  }
}
