import 'package:ez_book/src/blocs/reminder/focus/reminder_focus_bloc.dart';
import 'package:ez_book/src/pages/reminder/widgets/add_dialog.dart';
import 'package:ez_book/src/pages/reminder/widgets/available.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../blocs/reminder/core/reminder_bloc.dart';
import '../../blocs/user/info/user_info_bloc.dart';
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

    return Scaffold(
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              context
                  .read<ReminderFocusBloc>()
                  .add(ReminderFocusDeselectEvent());
            },
            child: SingleChildScrollView(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
                  ),
                  BlocBuilder<UserInfoBloc, UserInfoState>(
                      builder: (context, usrstate) {
                    if (usrstate is UserInfoPassive ||
                        usrstate is UserInfoInitial) {
                      return notSignedIn(context);
                    }

                    if (usrstate is UserInfoActive) {
                      return SignedInReminder(
                          user: usrstate.user,
                          settingsController: settingsController);
                    }
                    return const SizedBox.shrink();
                  })
                ]))),
        floatingActionButton: BlocBuilder<UserInfoBloc, UserInfoState>(
          builder: (context, state) {
            if (state is UserInfoActive) {
              return actionButtons(context);
            }

            return const SizedBox.shrink();
          },
        ));
  }

  Container notSignedIn(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return Container(
        margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.05),
        child: Column(
          children: [
            Icon(
              Icons.sentiment_dissatisfied,
              size: SizeConfig.screenWidth! * 0.375,
            ),
            Text(tr().reminder_signedout_info,
                style: TextStyle(fontSize: SizeConfig.fsize(0.05)))
          ],
        ));
  }

  Wrap actionButtons(BuildContext context) {
    var addDialogInstance = ReminderAddDialog(
        settingsController: settingsController, context: context);

    return Wrap(
      direction: Axis.vertical,
      children: [
        BlocBuilder<ReminderBloc, ReminderState>(builder: (context, state) {
          if (state is ReminderLoading) {
            return const SizedBox.shrink();
          }

          return Container(
              margin: EdgeInsets.only(bottom: SizeConfig.screenHeight! * 0.005),
              child: FloatingActionButton(
                  mini: true,
                  backgroundColor:
                      settingsController.themeMode == ThemeMode.light
                          ? const Color(0xff6200EE)
                          : const Color(0xffffffff),
                  child: Icon(Icons.autorenew,
                      size: SizeConfig.screenWidth! * 0.065,
                      color: settingsController.themeMode == ThemeMode.light
                          ? const Color(0xffffffff)
                          : const Color(0xffBB86FC)),
                  onPressed: () {
                    var userState =
                        context.read<UserInfoBloc>().state as UserInfoActive;
                    context.read<ReminderBloc>().add(ReminderLoadEvent(
                        requiredInfo: {'objectId': userState.user.objectId}));
                  }));
        }),
        Container(
            margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.005),
            child: FloatingActionButton(
                mini: true,
                backgroundColor: settingsController.themeMode == ThemeMode.light
                    ? const Color(0xff6200EE)
                    : const Color(0xffffffff),
                child: Icon(Icons.playlist_add,
                    size: SizeConfig.screenWidth! * 0.065,
                    color: settingsController.themeMode == ThemeMode.light
                        ? const Color(0xffffffff)
                        : const Color(0xffBB86FC)),
                onPressed: () async =>
                    addDialogInstance.display(settingsController)))
      ],
    );
  }
}
