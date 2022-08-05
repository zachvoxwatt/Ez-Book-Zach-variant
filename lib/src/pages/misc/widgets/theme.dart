import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class ThemeSetting extends StatelessWidget {
  const ThemeSetting({Key? k, required this.settingsController})
      : super(key: k);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return Container(
        decoration: itemBottomBorder(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(tr().misc_apptheme,
                style: TextStyle(fontSize: SizeConfig.fsize(0.04375))),
            IconButton(
              onPressed: () {
                settingsController.updateThemeMode(
                    settingsController.themeMode == ThemeMode.light
                        ? toggleTheme(context, true)
                        : toggleTheme(context, false));
              },
              icon: Icon(settingsController.themeMode == ThemeMode.light
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded),
            )
          ],
        ));
  }

  ThemeMode toggleTheme(BuildContext context, bool currentlyLight) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    SnackBar snackBar;
    ThemeMode returner;

    if (currentlyLight) {
      snackBar = SnackBar(
        content: Text(tr().misc_apptheme_change_dark),
        duration: const Duration(seconds: 3),
      );

      returner = ThemeMode.dark;
    } else {
      snackBar = SnackBar(
        content: Text(tr().misc_apptheme_change_light),
        duration: const Duration(seconds: 3),
      );

      returner = ThemeMode.light;
    }

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return returner;
  }

  BoxDecoration itemBottomBorder() {
    return BoxDecoration(
        border: Border(
            bottom: BorderSide(width: 1, color: itemBottomBorderColor())));
  }

  Color itemBottomBorderColor() {
    return settingsController.themeMode == ThemeMode.dark
        ? const Color(0xffffffff)
        : const Color(0xff000000);
  }
}
