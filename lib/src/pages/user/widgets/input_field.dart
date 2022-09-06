import 'package:ez_book/src/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/user/account/user_acc_bloc.dart';

class InputField extends StatelessWidget {
  final TextEditingController textCTRL;
  final bool isPassword, shouldValidate;
  final String placeholder;

  const InputField(
      {Key? k,
      required this.textCTRL,
      required this.isPassword,
      required this.shouldValidate,
      required this.placeholder})
      : super(key: k);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            top: SizeConfig.screenHeight! * 0.01,
            bottom: SizeConfig.screenHeight! * 0.01),
        child: TextField(
          onChanged: (value) {
            context
                .read<UserAccountBloc>()
                .add(UserAccountRegistryClearErrorEvent());
          },
          controller: textCTRL,
          obscureText: isPassword,
          decoration: InputDecoration(hintText: placeholder),
        ));
  }

  TextEditingController getTextCTRL() {
    return textCTRL;
  }
}
