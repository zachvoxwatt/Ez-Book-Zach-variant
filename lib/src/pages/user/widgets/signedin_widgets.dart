import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:ez_book/src/size_config.dart';
import 'package:flutter/material.dart';

class AccountSettingsCard extends StatelessWidget {
  final String label;
  final String data;
  final SettingsController settingsController;
  final roundBorder = BorderRadius.circular(8);

  AccountSettingsCard(
      {Key? key,
      required this.label,
      required this.settingsController,
      required this.data})
      : super(key: key);

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
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Success"),
                            content: Text("Saved successfully"),
                          );
                        });
                  },
                  child: Container(
                      padding:
                          EdgeInsets.all(SizeConfig.scaleEvenly(0.0000375)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label,
                                style: TextStyle(
                                    color: const Color(0x66ffffff),
                                    fontSize: SizeConfig.fsize(0.055),
                                    fontWeight: FontWeight.bold)),
                            Container(
                                margin: EdgeInsets.only(
                                    top: SizeConfig.screenHeight! * 0.01),
                                child: Text(data))
                          ]))),
            )));
  }
}
