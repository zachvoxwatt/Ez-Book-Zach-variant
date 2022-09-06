import 'package:ez_book/src/blocs/user/info/user_info_bloc.dart';
import 'package:ez_book/src/pages/user/user_signedin.dart';
import 'package:ez_book/src/pages/user/user_signedout.dart';
import 'package:ez_book/src/size_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import '../../settings/settings_controller.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key, required this.settingsController})
      : super(key: key);
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            physics: const BouncingScrollPhysics(),
            child: BlocBuilder<UserInfoBloc, UserInfoState>(
              builder: (context, state) {
                if (state is UserInfoActive) {
                  return UserSignedInScreen(
                      data: state.user, settingsController: settingsController);
                }

                if (state is UserInfoSignOutWaiting) {
                  return Column(
                    children: [
                      LinearProgressIndicator(
                        minHeight: SizeConfig.screenHeight! * 0.0125,
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.screenHeight! * 0.025),
                          child: Text(tr().user_signout_wait,
                              style:
                                  TextStyle(fontSize: SizeConfig.fsize(0.05))))
                    ],
                  );
                }

                if (state is UserInfoDeleteWaiting) {
                  return Column(
                    children: [
                      LinearProgressIndicator(
                        minHeight: SizeConfig.screenHeight! * 0.0125,
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.screenHeight! * 0.025),
                          child: Text(tr().user_signout_deleted_pending,
                              style:
                                  TextStyle(fontSize: SizeConfig.fsize(0.05))))
                    ],
                  );
                }

                return UserSignedOutScreen(
                    settingsController: settingsController);
              },
            )));
  }
}
