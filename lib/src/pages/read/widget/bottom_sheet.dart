import 'package:ez_book/src/blocs/display_settings/display_settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomSheetWidget extends StatefulWidget {
  final Function(TextStyle) onClickedConfirm;
  final Function onClickedClose;
  final Map settings;
  final SettingsController settingsController;
  const BottomSheetWidget(
      {Key? key,
      required this.onClickedClose,
      required this.onClickedConfirm,
      required this.settings,
      required this.settingsController})
      : super(key: key);

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  bool isSwitched = false;

  getSetting() {
    isSwitched = widget.settings['theme'];
  }

  @override
  void initState() {
    super.initState();
    getSetting();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.settings,
                size: 22,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                tr().settings_title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[800],
            height: 35,
          ),
          Text(
            tr().settings_font,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<DisplaySettingsBloc, DisplaySettingsState>(
              builder: (context, ffstate) {
                return DropdownButton<String>(
                    isExpanded: true,
                    iconSize: 16,
                    value: ffstate.fontFamily,
                    onChanged: (newValue) {
                      context.read<DisplaySettingsBloc>().add(
                          DisplaySettingsChange(
                              fontSize: ffstate.fontSize,
                              fontFamily: newValue!));
                    },
                    items: <String>[
                      'Roboto',
                      'Gideon Roman',
                      'Noto Serif',
                      'Redressed'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value,
                          child:
                              Text(value, style: TextStyle(fontFamily: value)));
                    }).toList());
              },
            ),
          ),
          Text(
            tr().settings_fontsize,
            textAlign: TextAlign.center,
          ),
          BlocBuilder<DisplaySettingsBloc, DisplaySettingsState>(
              builder: ((context, fsstate) {
            return Slider(
              value: fsstate.fontSize,
              onChanged: (newRating) {
                context.read<DisplaySettingsBloc>().add(DisplaySettingsChange(
                    fontSize: newRating, fontFamily: fsstate.fontFamily));
              },
              min: 12,
              max: 32,
              divisions: 12,
              label: '${fsstate.fontSize.floor()}',
            );
          })),
          Divider(
            thickness: 1,
            color: Colors.grey[800],
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(tr().settings_darktheme),
                const Spacer(),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                      widget.settingsController.updateThemeMode(
                          widget.settingsController.themeMode == ThemeMode.light
                              ? ThemeMode.dark
                              : ThemeMode.light);
                    });
                  },
                  activeTrackColor: const Color(0xFF6741FF),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          _buildEvelatedButton(
              Icons.save,
              tr().settings_confirm,
              const Color(0xFF6741FF),
              () => widget.onClickedConfirm(TextStyle(
                  fontSize: BlocProvider.of<DisplaySettingsBloc>(context)
                      .state
                      .fontSize,
                  fontWeight: FontWeight.normal,
                  fontFamily: BlocProvider.of<DisplaySettingsBloc>(context)
                      .state
                      .fontFamily))),
        ],
      ),
    );
  }

  Widget _buildEvelatedButton(
          IconData icon, String text, Color color, Function action) =>
      SizedBox(
        height: 40,
        width: 150,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: () => action(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
}
