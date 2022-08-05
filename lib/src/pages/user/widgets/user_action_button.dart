import 'package:ez_book/src/pages/user/widgets/register_widget.dart';
import 'package:ez_book/src/pages/user/widgets/signin_widget.dart';
import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:ez_book/src/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/user/account/user_acc_bloc.dart';

class UserLogButton extends StatelessWidget {
  final SettingsController settingsController;
  final String label;
  final Color color;
  final bool isRegister;

  const UserLogButton(
      {Key? k,
      required this.settingsController,
      required this.label,
      required this.color,
      required this.isRegister})
      : super(key: k);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth! * 0.5,
      height: SizeConfig.screenHeight! * 0.0675,
      child: isRegister
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: const RouteSettings(name: "/register"),
                        builder: (context) => RegisterScreen(
                            settingsController: settingsController,
                            fromSignin: false)));
              },
              child: Text(label,
                  style: TextStyle(
                      fontSize: SizeConfig.fsize(0.05),
                      fontWeight: FontWeight.bold)),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                context
                    .read<UserAccountBloc>()
                    .add(UserAccountRegistryIdleEvent());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: const RouteSettings(name: "/signin"),
                        builder: (context) => SignInScreen(
                            settingsController: settingsController,
                            fromRegister: false)));
              },
              child: Text(label,
                  style: TextStyle(
                      fontSize: SizeConfig.fsize(0.05),
                      fontWeight: FontWeight.bold)),
            ),
    );
  }
}
