import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../blocs/reminder/core/reminder_bloc.dart';
import '../../../blocs/reminder/creation/reminder_creation_bloc.dart';
import '../../../blocs/reminder/timepicker/time_picker_bloc.dart';
import '../../../blocs/user/info/user_info_bloc.dart';
import '../../../models/reminder.dart';
import '../../../size_config.dart';

class ReminderAddDialog {
  final SettingsController settingsController;
  final BuildContext context;
  final TextEditingController textCTRL = TextEditingController();
  var datagram = {};
  ReminderAddDialog({required this.settingsController, required this.context});

  void display(SettingsController settingsController) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    var stateCheck = context.read<ReminderBloc>().state;

    if (stateCheck is ReminderErrorNoConnection) {
      ScaffoldMessenger.of(context).clearSnackBars();
      var snaxbar = const SnackBar(
          content: Text(
              'An error occurred while trying to add reminder. \nReason: Could not reach the service!'));

      ScaffoldMessenger.of(context).showSnackBar(snaxbar);
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(tr().reminder_dialog_label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            content: BlocBuilder<ReminderCreationBloc, ReminderCreationState>(
              builder: (context, state) {
                if (state is ReminderCreationWaiting) {
                  return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [CircularProgressIndicator()]);
                }

                if (state is ReminderCreationSuccess) {
                  return successDialog(context);
                }

                return Column(mainAxisSize: MainAxisSize.min, children: [
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
                              color:
                                  settingsController.themeMode == ThemeMode.dark
                                      ? const Color(0XAAFFffff)
                                      : const Color(0XFF000000)),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<ReminderTimePickerBloc,
                                  ReminderTimePickerState>(
                              builder: (context, state) {
                            var timeData = '';
                            if (state is ReminderTimePickerInitial) {
                              timeData = tr().reminder_dialog_field_time;
                            }

                            if (state is ReminderTimePickerSelected) {
                              timeData = Reminder.formatDate(
                                  DateTime.parse(state.time));
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
                              var timeState =
                                  context.read<ReminderTimePickerBloc>().state;
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
                                  onCancel: () {
                                    context
                                        .read<ReminderTimePickerBloc>()
                                        .add(ReminderTimePickerResetEvent());
                                  },
                                  onChanged: (date) {},
                                  onConfirm: (date) {
                                    context.read<ReminderTimePickerBloc>().add(
                                        ReminderTimePickerSelectEvent(
                                            time: date.toString()));

                                    datagram['doneTime'] = date.toString();
                                  },
                                  currentTime:
                                      timeState is ReminderTimePickerInitial
                                          ? DateTime.now()
                                          : DateTime.parse((timeState
                                                  as ReminderTimePickerSelected)
                                              .time));
                            },
                          )
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: SizeConfig.screenWidth! * 0.2875,
                          child: ElevatedButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();

                                createReminder(datagram, context);
                              },
                              child: Text(tr().reminder_dialog_button_create,
                                  style: TextStyle(
                                      color: const Color(0XFFFFFFFF),
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          SizeConfig.screenWidth! * 0.05)))),
                      SizedBox(
                          width: SizeConfig.screenWidth! * 0.2875,
                          child: OutlinedButton(
                              onPressed: () => {
                                    FocusScope.of(context).unfocus(),
                                    Navigator.pop(context),
                                    context
                                        .read<ReminderTimePickerBloc>()
                                        .add(ReminderTimePickerResetEvent())
                                  },
                              child: Text(tr().reminder_dialog_button_cancel,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          SizeConfig.screenWidth! * 0.05)))),
                    ],
                  ),
                  BlocBuilder<ReminderCreationBloc, ReminderCreationState>(
                      builder: (context, state) {
                    if (state is ReminderCreationErrorNoConnection) {
                      return errorDialog(context);
                    }
                    return const SizedBox.shrink();
                  })
                ]);
              },
            ),
          );
        });
  }

  Container errorDialog(BuildContext context) {
    return Container(
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
          tr(context).reminder_dialog_error_connection,
          style: TextStyle(
              color: Colors.white, fontSize: SizeConfig.fsize(0.0375)),
        ));
  }

  Column successDialog(BuildContext context) {
    context.read<ReminderBloc>().add(ReminderSilentRefreshEvent(requiredInfo: {
          'objectId': (context.read<UserInfoBloc>().state as UserInfoActive)
              .user
              .objectId
        }));
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
          tr(context).reminder_dialog_create_success,
          style:
              TextStyle(color: Colors.white, fontSize: SizeConfig.fsize(0.05)),
        ),
      ),
      TextButton(
          onPressed: () async => {
                context
                    .read<ReminderCreationBloc>()
                    .add(ReminderCreationClearEvent()),
                Navigator.pop(context)
              },
          child: Text(tr(context).reminder_dialog_create_dismiss,
              style: TextStyle(fontSize: SizeConfig.screenWidth! * 0.05)))
    ]);
  }

  AppLocalizations tr(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  String formatDate(DateTime dt) {
    var dateFormat = DateFormat('dd/MM/yyyy, hh:mm');
    return dateFormat.format(dt);
  }

  void createReminder(data, BuildContext context) async {
    if (textCTRL.text.isEmpty) {
      data['content'] = '';
    }

    if (data['doneTime'] == null) {
      data['doneTime'] = '';
    }
    var toBeSent = {
      'ownerId':
          (context.read<UserInfoBloc>().state as UserInfoActive).user.objectId,
      'content': data['content'],
      'doneTime': data['doneTime'],
      'isCompleted': false
    };
    context
        .read<ReminderCreationBloc>()
        .add(ReminderCreationAddEvent(datagram: toBeSent));
  }
}
