import 'package:ez_book/src/blocs/reminder/update/reminder_update_bloc.dart';
import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../blocs/reminder/timepicker/time_picker_bloc.dart';
import '../../../models/reminder.dart';
import '../../../size_config.dart';

class ReminderEditDialog {
  final Reminder reminder;
  final BuildContext context;
  final SettingsController settingsController;
  final TextEditingController textCTRL = TextEditingController();
  var datagram = {};

  ReminderEditDialog(
      {required this.settingsController,
      required this.reminder,
      required this.context});

  void display() {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    if (reminder.content != null || reminder.content != '') {
      textCTRL.text = reminder.content!;
    }
    String timeData;
    if (reminder.doneTime != '') {
      timeData = Reminder.formatDate(DateTime.parse(reminder.doneTime!));
      context
          .read<ReminderTimePickerBloc>()
          .add(ReminderTimePickerSelectEvent(time: reminder.doneTime!));
    } else {
      timeData = 'Finish Time (OPTIONAL)';
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text(tr().reminder_dialog_edit_label,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              content: BlocBuilder<ReminderUpdateBloc, ReminderUpdateState>(
                  builder: (context, state) {
                if (state is ReminderUpdateWaiting ||
                    state is ReminderUpdateDeleteWaiting) {
                  return const CircularProgressIndicator();
                }
                if (state is ReminderUpdateSuccess) {
                  return editSuccessDialog(context);
                }

                if (state is ReminderUpdateDeleted) {
                  return deleteSuccessDialog(context);
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: SizeConfig.screenWidth! * 0.9,
                      child: TextField(
                        controller: textCTRL,
                        minLines: 1,
                        maxLines: 10,
                        style: TextStyle(fontSize: SizeConfig.fsize(0.0375)),
                        decoration: InputDecoration(
                            hintText: tr().reminder_dialog_field_content,
                            contentPadding: EdgeInsets.fromLTRB(
                                SizeConfig.screenWidth! * 0.025,
                                SizeConfig.screenHeight! * 0.01,
                                SizeConfig.screenWidth! * 0.025,
                                SizeConfig.screenHeight! * 0.01),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: settingsController.themeMode ==
                                            ThemeMode.dark
                                        ? const Color(0XAAFFffff)
                                        : const Color(0XFF000000)),
                                borderRadius: BorderRadius.circular(8)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: settingsController.themeMode ==
                                            ThemeMode.dark
                                        ? const Color(0XAAFFffff)
                                        : const Color(0XFF000000)),
                                borderRadius: BorderRadius.circular(8))),
                        onChanged: (value) {
                          if (value == reminder.content) {
                            datagram['content'] = '';
                            return;
                          }
                          datagram['content'] = value;
                        },
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.screenHeight! * 0.01,
                            bottom: SizeConfig.screenHeight! * 0.01),
                        padding: EdgeInsets.only(
                            left: SizeConfig.screenWidth! * 0.025),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: settingsController.themeMode ==
                                        ThemeMode.dark
                                    ? const Color(0XAAFFffff)
                                    : const Color(0XFF000000)),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlocBuilder<ReminderTimePickerBloc,
                                    ReminderTimePickerState>(
                                builder: (context, state) {
                              if (state is ReminderTimePickerSelected) {
                                timeData = Reminder.formatDate(
                                    DateTime.parse(state.time));
                              }

                              if (state is ReminderTimePickerCanceled) {
                                timeData = 'Finish Time (OPTIONAL)';
                              }

                              return Text(timeData,
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.screenWidth! * 0.0375));
                            }),
                            IconButton(
                              splashRadius: SizeConfig.screenWidth! * 0.05,
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.schedule),
                              onPressed: () {
                                var timeState = context
                                    .read<ReminderTimePickerBloc>()
                                    .state;
                                DatePicker.showDateTimePicker(context,
                                    locale: LocaleType.en,
                                    showTitleActions: true,
                                    minTime: DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day,
                                        DateTime.now().hour,
                                        DateTime.now().minute),
                                    maxTime: DateTime(
                                        DateTime.now().year + 10,
                                        DateTime.now().month,
                                        DateTime.now().day,
                                        23,
                                        59),
                                    currentTime:
                                        timeState is ReminderTimePickerSelected
                                            ? DateTime.parse(timeState.time)
                                            : null,
                                    onCancel: () {
                                      context
                                          .read<ReminderTimePickerBloc>()
                                          .add(ReminderTimePickerCancelEvent());

                                      datagram['doneTime'] = '';
                                    },
                                    onChanged: (date) {},
                                    onConfirm: (date) {
                                      context
                                          .read<ReminderTimePickerBloc>()
                                          .add(ReminderTimePickerSelectEvent(
                                              time: date.toString()));

                                      if (reminder.doneTime ==
                                          date.toString()) {
                                        datagram['doneTime'] = '';
                                        return;
                                      } else {
                                        datagram['doneTime'] = date.toString();
                                      }
                                    });
                              },
                            )
                          ],
                        )),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(tr().reminder_edit_dialog_finished_label),
                          Switch(
                              onChanged: (bool value) {},
                              value: reminder.isCompleted)
                        ]),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.screenHeight! * 0.025),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: SizeConfig.screenWidth! * 0.325,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    context.read<ReminderUpdateBloc>().add(
                                            ReminderUpdateInfoEvent(
                                                requiredInfo: {
                                              'objectId': reminder.reminderId
                                            },
                                                datagram: datagram));
                                  },
                                  child: Text(
                                      tr().reminder_edit_dialog_update_label,
                                      style: TextStyle(
                                          color: const Color(0XFFFFFFFF),
                                          fontWeight: FontWeight.bold,
                                          fontSize: SizeConfig.screenWidth! *
                                              0.05)))),
                          SizedBox(
                              width: SizeConfig.screenWidth! * 0.325,
                              child: OutlinedButton(
                                  onPressed: () => {
                                        FocusScope.of(context).unfocus(),
                                        Navigator.pop(context),
                                        context
                                            .read<ReminderTimePickerBloc>()
                                            .add(ReminderTimePickerResetEvent())
                                      },
                                  child: Text(
                                      tr().reminder_dialog_button_cancel,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: SizeConfig.screenWidth! *
                                              0.05)))),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () {
                            context.read<ReminderUpdateBloc>().add(
                                ReminderUpdateDeleteEvent(
                                    reminderId: reminder.reminderId));
                          },
                          child: Text(tr().reminder_edit_dialog_delete_label,
                              style: TextStyle(
                                  color: const Color(0XFFFFFFFF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.screenWidth! * 0.05))),
                    )
                  ],
                );
              }));
        });
  }

  Column editSuccessDialog(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
          margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.015),
          padding: EdgeInsets.fromLTRB(
              SizeConfig.screenWidth! * 0.025,
              SizeConfig.screenHeight! * 0.0075,
              SizeConfig.screenWidth! * 0.025,
              SizeConfig.screenHeight! * 0.0075),
          decoration: BoxDecoration(
              color: const Color(0xff03c04a),
              border: Border.all(width: 2, color: const Color(0xff99edc3)),
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            tr(context).reminder_dialog_edit_success_label,
            style: const TextStyle(color: Colors.white),
          )),
      TextButton(
        onPressed: () {
          context
              .read<ReminderUpdateBloc>()
              .add(ReminderUpdateToInitialEvent());
          Navigator.pop(context);
        },
        child: Text(tr(context).reminder_edit_dialog_dismiss_label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: SizeConfig.fsize(0.04375))),
      )
    ]);
  }

  Column deleteSuccessDialog(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
          margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.015),
          padding: EdgeInsets.fromLTRB(
              SizeConfig.screenWidth! * 0.025,
              SizeConfig.screenHeight! * 0.0075,
              SizeConfig.screenWidth! * 0.025,
              SizeConfig.screenHeight! * 0.0075),
          decoration: BoxDecoration(
              color: const Color(0xff800000),
              border: Border.all(width: 2, color: const Color(0xfff08080)),
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            tr(context).reminder_edit_dialog_deleted_message,
            style: const TextStyle(color: Colors.white),
          )),
      TextButton(
        onPressed: () {
          context
              .read<ReminderUpdateBloc>()
              .add(ReminderUpdateToInitialEvent());
          Navigator.pop(context);
        },
        child: Text(tr(context).reminder_edit_dialog_dismiss_label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: SizeConfig.fsize(0.04375))),
      )
    ]);
  }

  AppLocalizations tr(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}
