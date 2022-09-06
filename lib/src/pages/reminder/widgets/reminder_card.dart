import 'package:ez_book/src/blocs/reminder/focus/reminder_focus_bloc.dart';
import 'package:ez_book/src/pages/reminder/widgets/edit_dialog.dart';
import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ez_book/src/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/reminder/update/reminder_update_bloc.dart';
import '../../../models/reminder.dart';

class ReminderCard extends StatelessWidget {
  final SettingsController settingsController;
  final Reminder reminder;
  final bool isSelected;
  const ReminderCard(
      {Key? key,
      required this.isSelected,
      required this.reminder,
      required this.settingsController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return GestureDetector(
        onTap: () {
          context
              .read<ReminderFocusBloc>()
              .add(ReminderFocusSelectEvent(selectedReminder: reminder));
        },
        child: Container(
            width: SizeConfig.screenWidth!,
            margin: EdgeInsets.fromLTRB(
                SizeConfig.screenWidth! * 0.0375,
                SizeConfig.screenHeight! * 0.0075,
                SizeConfig.screenWidth! * 0.0375,
                SizeConfig.screenHeight! * 0.0175),
            padding:
                EdgeInsets.fromLTRB(0, SizeConfig.screenHeight! * 0.0175, 0, 0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color: settingsController.themeMode == ThemeMode.light
                            ? const Color(0xff000000)
                            : const Color(0xffffffff)))),
            child: Column(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                    margin:
                        EdgeInsets.only(right: SizeConfig.screenWidth! * 0.01),
                    child: IconButton(
                        splashRadius: SizeConfig.screenWidth! * 0.04,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: reminder.isCompleted
                            ? Icon(Icons.radio_button_checked,
                                color: settingsController.themeMode ==
                                        ThemeMode.light
                                    ? const Color(0xff6200EE)
                                    : const Color(0xffbb86fc))
                            : Icon(Icons.radio_button_unchecked,
                                color: settingsController.themeMode ==
                                        ThemeMode.light
                                    ? const Color(0xff6200EE)
                                    : const Color(0xffbb86fc)),
                        onPressed: () => context.read<ReminderUpdateBloc>().add(
                            ReminderUpdateCompletionEvent(
                                reminderId: reminder.reminderId,
                                isCompleted: reminder.isCompleted)))),
                SizedBox(
                    width: SizeConfig.screenWidth! * 0.76,
                    child: Text(
                      reminder.content == ''
                          ? tr().reminder_card_default_content
                          : reminder.content!,
                      style: TextStyle(fontSize: SizeConfig.fsize(0.055)),
                      maxLines: 200,
                      overflow: TextOverflow.ellipsis,
                    )),
                !isSelected
                    ? const SizedBox.shrink()
                    : Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(
                            left: SizeConfig.screenWidth! * 0.01),
                        child: IconButton(
                            splashRadius: SizeConfig.screenWidth! * 0.04,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              Icons.info,
                              color: settingsController.themeMode ==
                                      ThemeMode.light
                                  ? const Color(0xff6200EE)
                                  : const Color(0xffbb86fc),
                            ),
                            onPressed: () async =>
                                editReminderDialog(context))),
              ]),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                      top: SizeConfig.screenHeight! * 0.005,
                      bottom: SizeConfig.screenHeight! * 0.01),
                  child: Column(children: [
                    reminder.doneTime == null || reminder.doneTime == ''
                        ? const SizedBox.shrink()
                        : Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              processTimeString(reminder.doneTime!),
                              style: TextStyle(
                                  color: processColor(reminder.doneTime!)),
                            )),
                    reminder.bookId == null || reminder.bookId == ''
                        ? const SizedBox.shrink()
                        : Container(
                            alignment: Alignment.centerLeft,
                            child: Text(reminder.bookId!,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: settingsController.themeMode ==
                                            ThemeMode.dark
                                        ? const Color(0XFF9897A9)
                                        : const Color(0XFF3E3D53))))
                  ]))
            ])));
  }

  void editReminderDialog(BuildContext context) async {
    var editor = ReminderEditDialog(
        context: context,
        settingsController: settingsController,
        reminder: reminder);

    editor.display();
  }

  Color processColor(String dt) {
    var currentDate = DateTime.now();
    var givenDate = DateTime.parse(dt);
    Color returnColor;

    if (givenDate.compareTo(currentDate) < 0) {
      returnColor = const Color(0XFFBF1C3E);
    } else {
      returnColor = const Color(0XFF808080);
    }

    return returnColor;
  }

  String processTimeString(String dt) {
    var returnString = Reminder.formatDate(DateTime.parse(dt));

    var currentDate = DateTime.now();
    var givenDate = DateTime.parse(dt);

    if (givenDate.compareTo(currentDate) < 0) {
      returnString += '💥';
    }

    return returnString;
  }
}
