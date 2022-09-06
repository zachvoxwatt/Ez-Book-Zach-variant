import 'package:ez_book/src/blocs/reminder/creation/reminder_creation_bloc.dart';
import 'package:ez_book/src/blocs/reminder/focus/reminder_focus_bloc.dart';
import 'package:ez_book/src/blocs/reminder/update/reminder_update_bloc.dart';
import 'package:ez_book/src/blocs/user/info/user_info_bloc.dart';
import 'package:ez_book/src/pages/reminder/widgets/reminder_card.dart';
import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:ez_book/src/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/reminder/core/reminder_bloc.dart';
import '../../../blocs/reminder/timepicker/time_picker_bloc.dart';
import '../../../models/user.dart';

class SignedInReminder extends StatelessWidget {
  final User user;
  final SettingsController settingsController;
  const SignedInReminder(
      {Key? k, required this.user, required this.settingsController})
      : super(key: k);

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    if (context.read<ReminderBloc>().state is ReminderInitial &&
        context.read<UserInfoBloc>().state is UserInfoActive) {
      context
          .read<ReminderBloc>()
          .add(ReminderLoadEvent(requiredInfo: {'objectId': user.objectId}));
    }

    return Container(
        margin: EdgeInsets.only(
            right: SizeConfig.screenWidth! * 0.01,
            left: SizeConfig.screenWidth! * 0.01),
        child:
            BlocBuilder<ReminderBloc, ReminderState>(builder: (context, state) {
          if (state is ReminderLoading) {
            return pollingWidget(context);
          }

          if (state is ReminderLoaded) {
            if (state.reminderList.isEmpty) {
              return Container(
                  margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.05),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_box_outline_blank,
                        size: SizeConfig.screenWidth! * 0.375,
                      ),
                      Text(tr().reminder_signedin_no_reminder,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: SizeConfig.fsize(0.05)))
                    ],
                  ));
            } else {
              return resultsWidget(context, state);
            }
          }

          if (state is ReminderErrorNoConnection) {
            return Container(
                margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.3),
                child: Text(
                  tr().ftb_poll_err_unreachable,
                  style: TextStyle(fontSize: SizeConfig.fsize(0.05)),
                  textAlign: TextAlign.center,
                ));
          }

          return const SizedBox.shrink();
        }));
  }

  BlocBuilder resultsWidget(BuildContext context, ReminderLoaded state) {
    return BlocBuilder<ReminderFocusBloc, ReminderFocusState>(
        builder: (context, remState) {
      return Column(children: [
        (ListView.builder(
            padding: const EdgeInsets.only(top: 0),
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.reminderList.length,
            itemBuilder: ((context, indx) {
              if (remState is ReminderFocusInitial) {
                return ReminderCard(
                  settingsController: settingsController,
                  isSelected: false,
                  reminder: state.reminderList[indx],
                );
              }

              if (remState is ReminderFocusSelected) {
                return ReminderCard(
                  settingsController: settingsController,
                  isSelected:
                      remState.selectedReminder == state.reminderList[indx]
                          ? true
                          : false,
                  reminder: state.reminderList[indx],
                );
              }

              return const SizedBox.shrink();
            }))),
        BlocListener<ReminderUpdateBloc, ReminderUpdateState>(
          listener: ((context, state) {
            if (state is ReminderUpdateDeleted) {
              context.read<ReminderBloc>().add(
                      ReminderSilentRefreshEvent(requiredInfo: {
                    'objectId':
                        (context.read<UserInfoBloc>().state as UserInfoActive)
                            .user
                            .objectId
                  }));
            }

            if (state is ReminderUpdateSuccess) {
              context.read<ReminderBloc>().add(
                      ReminderSilentRefreshEvent(requiredInfo: {
                    'objectId':
                        (context.read<UserInfoBloc>().state as UserInfoActive)
                            .user
                            .objectId
                  }));

              if (state.autoRefresh) {
                context
                    .read<ReminderUpdateBloc>()
                    .add(ReminderUpdateToInitialEvent());
              }
            }
          }),
          child: const SizedBox.shrink(),
        )
      ]);
    });
  }

  Container pollingWidget(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    context.read<ReminderCreationBloc>().add(ReminderCreationClearEvent());
    context.read<ReminderTimePickerBloc>().add(ReminderTimePickerResetEvent());

    return Container(
        margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.3),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            Container(
                margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.0125),
                child: Text(tr().ftb_poll_polling))
          ],
        ));
  }
}
