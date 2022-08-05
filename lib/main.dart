import 'package:ez_book/src/services/blocobserver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  BlocOverrides.runZoned(() {
    final settingsController = SettingsController(SettingsService());
    settingsController
        .loadSettings(); // Set up the SettingsController, which will glue user settings to multiple Flutter Widgets.

    runApp(MyApp(settingsController: settingsController));
  }, blocObserver: AppBlocObserver());
}
