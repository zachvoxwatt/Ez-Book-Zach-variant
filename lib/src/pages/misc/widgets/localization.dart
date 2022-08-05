import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../blocs/language/language_bloc.dart';
import '../../../size_config.dart';

class LocalizationSetting extends StatelessWidget {
  const LocalizationSetting({Key? k, required this.settingsController})
      : super(key: k);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return
//        decoration: itemBottomBorder(), // <- Add this line when adding new settings to Miscellaneous
        Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(tr().misc_lang,
            style: TextStyle(fontSize: SizeConfig.fsize(0.04375))),
        PopupMenuButton(
            onSelected: (String value) async {
              ScaffoldMessenger.of(context).clearSnackBars();
              context
                  .read<LanguageBloc>()
                  .add(LanguageChangeEvent(locale: Locale(value, '')));

              await Future.delayed(const Duration(milliseconds: 250));
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(tr().misc_lang_change)));
            },
            position: PopupMenuPosition.under,
            shape: Border.all(width: 0),
            icon: Icon(
              Icons.language,
              color: settingsController.themeMode == ThemeMode.dark
                  ? const Color(0xffffffff)
                  : const Color(0xff000000),
            ),
            itemBuilder: ((context) => menuItems(context)))
      ],
    );
  }

  List<PopupMenuItem<String>> menuItems(BuildContext context) {
    var selectedLocale =
        BlocProvider.of<LanguageBloc>(context).state.locale.toString();
    List<PopupMenuItem<String>> returner = [];

    locales.forEach((k, v) {
      if (k == selectedLocale) {
        returner.add(PopupMenuItem(
            value: k,
            child: Text(v, style: const TextStyle(color: Color(0xffb380f0)))));
      } else {
        returner.add(PopupMenuItem(value: k, child: Text(v)));
      }
    });
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

var locales = {"en": "English", "vi": "Tiếng Việt"};
