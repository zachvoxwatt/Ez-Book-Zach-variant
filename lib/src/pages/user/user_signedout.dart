import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../blocs/user/account/user_acc_bloc.dart';
import '../../models/user.dart';
import '../../settings/settings_controller.dart';
import '../../size_config.dart';
import 'widgets/user_action_button.dart';

class UserSignedOutScreen extends StatelessWidget {
  final SettingsController settingsController;

  const UserSignedOutScreen({Key? k, required this.settingsController})
      : super(key: k);

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return Column(children: [
      Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(
            top: SizeConfig.screenHeight! * 0.0075,
            left: SizeConfig.screenWidth! * 0.05,
            right: SizeConfig.screenWidth! * 0.05),
        child: Text(tr().tab_user,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.screenWidth! * 0.1)),
      ),
      buttons(context),
      userStateNotifier(context)
    ]);
  }

  Column buttons(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return Column(children: [
      Container(
          margin: EdgeInsets.only(
              top: SizeConfig.screenHeight! * 0.05,
              bottom: SizeConfig.screenHeight! * 0.005),
          child: UserLogButton(
              isRegister: false,
              settingsController: settingsController,
              label: tr().user_signin,
              color: const Color(0xffabcdef))),
      Container(
        margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.005),
        child: UserLogButton(
            isRegister: true,
            settingsController: settingsController,
            label: tr().user_reg,
            color: const Color(0xffabcdef)),
      )
    ]);
  }

  BlocBuilder userStateNotifier(BuildContext context) {
    return BlocBuilder<UserAccountBloc, UserAccountState>(
      builder: (context, state) {
        if (state is UserAccountRegistrySuccess) {
          return Container(
              margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.025),
              padding: EdgeInsets.only(
                  top: SizeConfig.screenHeight! * 0.005,
                  bottom: SizeConfig.screenHeight! * 0.005,
                  left: SizeConfig.screenWidth! * 0.025,
                  right: SizeConfig.screenWidth! * 0.025),
              decoration: BoxDecoration(
                  color: const Color(0xff03c04a),
                  border: Border.all(width: 2, color: const Color(0xff99edc3)),
                  borderRadius: BorderRadius.circular(8)),
              child: const Text(
                'Successfully registered!\nPlease sign in to continue',
                textAlign: TextAlign.center,
              ));
        }

        return const SizedBox.shrink();
      },
    );
  }
}