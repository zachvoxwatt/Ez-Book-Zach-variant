import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../blocs/display_settings/display_settings_bloc.dart';
import '../../../size_config.dart';

class FontSetting extends StatelessWidget {
  const FontSetting({Key? k, required this.settingsController}) : super(key: k);

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
            Text(tr().misc_font_settings,
                style: TextStyle(fontSize: SizeConfig.fsize(0.04375))),
            BlocBuilder<DisplaySettingsBloc, DisplaySettingsState>(
                builder: ((context, state) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(
                          top: SizeConfig.screenHeight! * 0.0075,
                          bottom: SizeConfig.screenHeight! * 0.0075,
                          left: SizeConfig.screenWidth! * 0.03,
                          right: SizeConfig.screenWidth! * 0.03),
                      minimumSize: Size.zero),
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return modalBottomSettingSheet(context);
                        });
                  },
                  child: Text(tr().misc_font_settings_button,
                      style: TextStyle(
                          fontSize: SizeConfig.fsize(0.04375),
                          fontWeight: FontWeight.bold)));
            }))
          ],
        ));
  }

  Container modalBottomSettingSheet(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return Container(
        height: SizeConfig.screenHeight! * 0.25,
        margin: EdgeInsets.fromLTRB(
            SizeConfig.screenWidth! * 0.1,
            SizeConfig.screenHeight! * 0.025,
            SizeConfig.screenWidth! * 0.1,
            SizeConfig.screenHeight! * 0.025),
        child: BlocBuilder<DisplaySettingsBloc, DisplaySettingsState>(
          builder: ((context, fstate) {
            return Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  Icons.text_format,
                  size: SizeConfig.screenWidth! * 0.07,
                ),
                Text(tr().misc_font_settings,
                    style: TextStyle(fontSize: SizeConfig.fsize(0.06375)))
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('${tr().settings_fontsize}: ${fstate.fontSize.floor()}',
                    style: TextStyle(fontSize: SizeConfig.fsize(0.0475))),
                Slider(
                  label: fstate.fontSize.floor().toString(),
                  divisions: 12,
                  min: 12,
                  max: 32,
                  onChanged: (double value) {
                    context.read<DisplaySettingsBloc>().add(
                        DisplaySettingsChange(
                            fontSize: value, fontFamily: fstate.fontFamily));
                  },
                  value: fstate.fontSize,
                )
              ]),
              displayFontFamilySetting(context),
              ElevatedButton(
                  onPressed: () => {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(tr().misc_font_settings_changed),
                          duration: const Duration(seconds: 3),
                        )),
                        Navigator.pop(context)
                      },
                  child: Text(tr().settings_confirm,
                      style: TextStyle(fontSize: SizeConfig.fsize(0.05))))
            ]);
          }),
        ));
  }

  Container displayFontFamilySetting(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    List<DropdownMenuItem<String>> menuItems() {
      return ['Roboto', 'Gideon Roman', 'Noto Serif', 'Redressed']
          .map((itor) => DropdownMenuItem<String>(
              value: itor,
              child: Text(
                itor,
                style: TextStyle(
                    fontFamily: itor, fontSize: SizeConfig.fsize(0.0475)),
              )))
          .toList();
    }

    return Container(
        padding: EdgeInsets.only(
            top: SizeConfig.screenHeight! * 0.015,
            bottom: SizeConfig.screenHeight! * 0.015),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(tr().settings_font,
                style: TextStyle(fontSize: SizeConfig.fsize(0.0475))),
            BlocBuilder<DisplaySettingsBloc, DisplaySettingsState>(
                builder: ((context, state) {
              return DropdownButton(
//          Makes the dropdown button underline disappear.
//                    |
//                    |
//                    |
//                    V
                  icon: const Visibility(
                    visible: true,
                    child: Icon(
                      Icons.expand_more,
                    ),
                  ),
                  underline: Container(),
                  elevation: 1,
                  borderRadius: BorderRadius.circular(8),
                  alignment: Alignment.centerRight,
                  isDense: true,
                  value: state.fontFamily,
                  items: menuItems(),
                  onChanged: (String? value) {
                    context.read<DisplaySettingsBloc>().add(
                        DisplaySettingsChange(
                            fontSize: state.fontSize, fontFamily: value!));
                  });
            }))
          ],
        ));
  }

  BoxDecoration itemBottomBorder() {
    return BoxDecoration(
        border: Border(
            bottom: BorderSide(
                width: 1,
                color: settingsController.themeMode == ThemeMode.dark
                    ? const Color(0xffffffff)
                    : const Color(0xff000000))));
  }
}
