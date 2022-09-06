import 'package:ez_book/src/blocs/user/account/user_acc_bloc.dart';
import 'package:ez_book/src/models/error.dart';
import 'package:ez_book/src/services/repositories/ping.dart';
import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:ez_book/src/size_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../blocs/user/account/validator.dart';
import '../../../blocs/user/info/user_info_bloc.dart';

class AccountSettingsCard extends StatelessWidget {
  final Validator validator;
  final String label;
  final String data;
  final String property;
  final SettingsController settingsController;
  final TextEditingController textCTRL = TextEditingController();
  final roundBorder = BorderRadius.circular(8);

  AccountSettingsCard(
      {Key? key,
      required this.validator,
      required this.property,
      required this.label,
      required this.settingsController,
      required this.data})
      : super(key: key) {
    label == 'Password' || (label == 'Phone' && data == 'N/A')
        ? null
        : textCTRL.text = data;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: SizeConfig.screenWidth,
        child: Card(
            shape: RoundedRectangleBorder(borderRadius: roundBorder),
            child: Material(
              borderRadius: roundBorder,
              child: InkWell(
                  customBorder:
                      RoundedRectangleBorder(borderRadius: roundBorder),
                  onTap: () async => popUpEditForm(context),
                  child: Container(
                      padding:
                          EdgeInsets.all(SizeConfig.scaleEvenly(0.0000375)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label,
                                style: TextStyle(
                                    color: settingsController.themeMode ==
                                            ThemeMode.dark
                                        ? const Color(0x66ffffff)
                                        : const Color(0xff000000),
                                    fontSize: SizeConfig.fsize(0.055),
                                    fontWeight: FontWeight.bold)),
                            Container(
                                margin: EdgeInsets.only(
                                    top: SizeConfig.screenHeight! * 0.01),
                                child: Text(data))
                          ]))),
            )));
  }

  void popUpEditForm(BuildContext context) async {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
                "${tr().user_signedin_edit_label_prefix} ${label.toLowerCase()}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(controller: textCTRL),
              Container(
                  margin:
                      EdgeInsets.only(top: SizeConfig.screenHeight! * 0.015),
                  child: BlocBuilder<UserAccountBloc, UserAccountState>(
                    builder: (context, state) {
                      if (state is UserAccountEditWorking) {
                        return const CircularProgressIndicator();
                      }

                      if (state is UserAccountEditSuccess) {
                        return editSuccessDialog(context);
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: SizeConfig.screenWidth! * 0.2875,
                              child: IconButton(
                                  splashColor: const Color(0x77318a4a),
                                  splashRadius: SizeConfig.screenWidth! * 0.05,
                                  onPressed: () async =>
                                      updateInfo(context, textCTRL.text),
                                  iconSize: SizeConfig.screenWidth! * 0.1,
                                  icon: const Icon(Icons.check,
                                      color: Colors.green))),
                          SizedBox(
                              width: SizeConfig.screenWidth! * 0.2875,
                              child: IconButton(
                                  splashColor: const Color(0x77be382d),
                                  splashRadius: SizeConfig.screenWidth! * 0.05,
                                  onPressed: () => {
                                        context
                                            .read<UserAccountBloc>()
                                            .add(UserAccountDoneUpdateEvent()),
                                        Navigator.pop(context)
                                      },
                                  iconSize: SizeConfig.screenWidth! * 0.1,
                                  icon: const Icon(Icons.close,
                                      color: Colors.red))),
                        ],
                      );
                    },
                  )),
              BlocBuilder<UserAccountBloc, UserAccountState>(
                builder: (context, state) {
                  if (state is UserAccountEditTypoError) {
                    return editFailedDialog(context, true);
                  }

                  if (state is UserAccountEditFailed) {
                    return editFailedDialog(context, false);
                  }

                  if (state is UserAccountEditSameInfo) {
                    return editSameInfoDialog(context);
                  }

                  return const SizedBox.shrink();
                },
              )
            ]),
          );
        });
  }

  void updateInfo(BuildContext context, String value) async {
    FocusScope.of(context).unfocus();

    context.read<UserAccountBloc>().add(UserAccountEditProgressEvent());

    var pingTest = await PingRepository.pingServer();
    if (!pingTest) {
      context.read<UserAccountBloc>().add(UserAccountEditNoConnectionEvent());
      return;
    }

    var obj = context.read<UserInfoBloc>().state as UserInfoActive;

    if (value == data) {
      context.read<UserAccountBloc>().add(UserAccountEditSameInfoEvent());
      return;
    }

    if (!validator.validate(value)) {
      context.read<UserAccountBloc>().add(UserAccountEditTypoErrorEvent());
      return;
    }

    var toBeSent = {property: value};
    var requiredObject = {
      'sessionToken': obj.user.sessionToken,
      'objectId': obj.user.objectId
    };
    context.read<UserAccountBloc>().add(UserAccountEditUpdateEvent(
        requiredInfo: requiredObject, toBeSent: toBeSent));
  }

  Column editSuccessDialog(BuildContext context) {
    return Column(children: [
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
          child: const Text(
            'Credentials Changed',
            style: TextStyle(color: Colors.white),
          )),
      TextButton(
        onPressed: () {
          var newData =
              context.read<UserAccountBloc>().state as UserAccountEditSuccess;

          context
              .read<UserInfoBloc>()
              .add(UserInfoSetEvent(user: newData.user));
          context.read<UserAccountBloc>().add(UserAccountDoneUpdateEvent());
          Navigator.pop(context);
        },
        child: Text('Dismiss',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: SizeConfig.fsize(0.04375))),
      )
    ]);
  }

  Container editFailedDialog(BuildContext context, bool isTypo) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    if (isTypo) {
      return Container(
          margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.015),
          padding: EdgeInsets.fromLTRB(
              SizeConfig.screenWidth! * 0.025,
              SizeConfig.screenHeight! * 0.0075,
              SizeConfig.screenWidth! * 0.025,
              SizeConfig.screenHeight! * 0.0075),
          decoration: errorDialogStylings,
          child: Text(
            tr().user_signedin_edit_err_typo,
            style: TextStyle(
                color: Colors.white, fontSize: SizeConfig.fsize(0.0375)),
          ));
    } else {
      var errCode =
          context.read<UserAccountBloc>().state as UserAccountEditFailed;
      return Container(
          margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.015),
          padding: EdgeInsets.fromLTRB(
              SizeConfig.screenWidth! * 0.025,
              SizeConfig.screenHeight! * 0.0075,
              SizeConfig.screenWidth! * 0.025,
              SizeConfig.screenHeight! * 0.0075),
          decoration: errorDialogStylings,
          child: Text(
            UpdateError.lookup(context, errCode.errorCode),
            style: TextStyle(
                color: Colors.white, fontSize: SizeConfig.fsize(0.0375)),
          ));
    }
  }

  Container editSameInfoDialog(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return Container(
        margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.015),
        padding: EdgeInsets.fromLTRB(
            SizeConfig.screenWidth! * 0.025,
            SizeConfig.screenHeight! * 0.0075,
            SizeConfig.screenWidth! * 0.025,
            SizeConfig.screenHeight! * 0.0075),
        decoration: unchangedDialogStylings,
        child: Text(tr().user_signedin_edit_err_sameinfo,
            style: TextStyle(
                color: Colors.white, fontSize: SizeConfig.fsize(0.0375))));
  }

// this is a  bunch of nonsense thingies
  final errorDialogStylings = BoxDecoration(
      color: const Color(0xff800000),
      border: Border.all(width: 2, color: const Color(0xfff08080)),
      borderRadius: BorderRadius.circular(8));

  final unchangedDialogStylings = BoxDecoration(
      color: const Color(0xffC58F00),
      border: Border.all(width: 2, color: const Color(0xffffb101)),
      borderRadius: BorderRadius.circular(8));
}
