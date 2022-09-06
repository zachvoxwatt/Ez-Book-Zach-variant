import 'dart:ui';

import 'package:ez_book/src/blocs/language/language_bloc.dart';
import 'package:ez_book/src/blocs/reminder/core/reminder_bloc.dart';
import 'package:ez_book/src/blocs/reminder/focus/reminder_focus_bloc.dart';
import 'package:ez_book/src/blocs/user/info/user_info_bloc.dart';
import 'package:ez_book/src/pages/user/user.dart';
import 'package:ez_book/src/services/repositories/reminder.dart';
import 'package:ez_book/src/services/repositories/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ez_book/src/pages/home/home.dart';
import 'package:ez_book/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'blocs/display_settings/display_settings_bloc.dart';
import 'blocs/ft_book/ft_book_bloc.dart';
import 'blocs/reminder/creation/reminder_creation_bloc.dart';
import 'blocs/reminder/timepicker/time_picker_bloc.dart';
import 'blocs/reminder/update/reminder_update_bloc.dart';
import 'blocs/user/account/user_acc_bloc.dart';
import 'services/networking/book_client.dart';
import 'services/networking/reminder_client.dart';
import 'services/networking/user_client.dart';
import 'services/repositories/book.dart';
import 'settings/settings_controller.dart';
import 'size_config.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
              create: (context) => BookRepository(bookcl: BookClient())),
          RepositoryProvider(
              create: (context) => UserRepository(usercl: UserClient())),
          RepositoryProvider(
              create: (context) => ReminderRepository(remcl: ReminderClient()))
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) =>
                      BookBloc(repo: context.read<BookRepository>())),
              BlocProvider(
                  create: (context) =>
                      UserAccountBloc(repo: context.read<UserRepository>())),
              BlocProvider(
                  create: (context) =>
                      UserInfoBloc(repo: context.read<UserRepository>())),
              BlocProvider(
                  create: (context) =>
                      ReminderBloc(repo: context.read<ReminderRepository>())),
              BlocProvider(
                  create: (context) => ReminderCreationBloc(
                      repo: context.read<ReminderRepository>())),
              BlocProvider(
                  create: (context) => ReminderUpdateBloc(
                      repo: context.read<ReminderRepository>())),
              BlocProvider(create: (context) => LanguageBloc()),
              BlocProvider(create: (context) => DisplaySettingsBloc()),
              BlocProvider(create: (context) => ReminderFocusBloc()),
              BlocProvider(create: (context) => ReminderTimePickerBloc())
            ],
            child: BlocBuilder<LanguageBloc, LanguageState>(
                builder: (context, localeState) {
              return AnimatedBuilder(
                animation: settingsController,
                builder: (BuildContext context, Widget? child) {
                  return MaterialApp(
                    scrollBehavior: MyCustomScrollBehavior(),
                    debugShowCheckedModeBanner: false,
                    // Providing a restorationScopeId allows the Navigator built by the
                    // MaterialApp to restore the navigation stack when a user leaves and
                    // returns to the app after it has been killed while running in the
                    // background.
                    restorationScopeId: 'app',

                    // Provide the generated AppLocalizations to the MaterialApp. This
                    // allows descendant Widgets to display the correct translations
                    // depending on the user's locale.
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: const [
                      Locale('en', ''), // English, no country code
                      Locale('vi', '') // Vietnamese, no country code;
                    ],
                    locale: localeState.locale,

                    // Use AppLocalizations to configure the correct application title
                    // depending on the user's locale.
                    //
                    // The appTitle is defined in .arb files found in the localization
                    // directory.
                    onGenerateTitle: (BuildContext context) =>
                        AppLocalizations.of(context)!.appTitle,

                    // Define a light and dark color theme. Then, read the user's
                    // preferred ThemeMode (light, dark, or system default) from the
                    // SettingsController to display the correct theme.
                    theme: Themes.lightTheme,
                    darkTheme: Themes.datkTheme,
                    themeMode: settingsController.themeMode,
                    initialRoute: '/',
                    routes: {
                      '/user': (context) => UserScreen(
                            settingsController: settingsController,
                          )
                    },

                    // Define a function to handle named routes in order to support
                    // Flutter web url navigation and deep linking.
                    onGenerateRoute: (RouteSettings routeSettings) {
                      return MaterialPageRoute<void>(
                        settings: routeSettings,
                        builder: (BuildContext context) {
                          switch (routeSettings.name) {
                            default:
                              SizeConfig().init(context);

                              return HomePage(
                                settingsController: settingsController,
                              );
                          }
                        },
                      );
                    },
                  );
                },
              );
            })));
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
