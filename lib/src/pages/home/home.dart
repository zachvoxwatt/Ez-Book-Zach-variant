import 'package:ez_book/src/pages/misc/misc.dart';
import 'package:flutter/material.dart';
import 'package:ez_book/src/pages/home/widget/custom_app_bar.dart';
import 'package:ez_book/src/pages/home/widget/movie_header.dart';
import 'package:ez_book/src/pages/home/widget/category.dart';
import 'package:ez_book/src/pages/home/widget/trending_movies.dart';
import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../size_config.dart';
import '../ft_books/ft_books.dart';
import '../reminder/reminder.dart';
import '../user/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.settingsController})
      : super(key: key);
  final SettingsController settingsController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          onPageChanged: ((value) => setState(() {
                currentIndex = value;
              })),
          controller: pageController,
          physics: const BouncingScrollPhysics(),
          children: [
            Home(settingsController: widget.settingsController),
            FeaturedBooks(settingsController: widget.settingsController),
            ReminderScreen(settingsController: widget.settingsController),
            UserScreen(settingsController: widget.settingsController),
            MiscellaneousScreen(settingsController: widget.settingsController)
          ]),
      bottomNavigationBar: _buildBottonBar(context),
    );
  }

  BottomNavigationBar _buildBottonBar(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: (index) => setState(() {
              currentIndex = index;
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn);
            }),
        selectedItemColor: const Color(0xFF6741FF),
        items: [
          BottomNavigationBarItem(
              label: tr().tab_home, icon: const Icon(Icons.home_rounded)),
          BottomNavigationBarItem(
              label: tr().tab_ftb, icon: const Icon(Icons.menu_book_rounded)),
          BottomNavigationBarItem(
              label: tr().tab_reminder, icon: const Icon(Icons.event)),
          BottomNavigationBarItem(
              label: tr().tab_user, icon: const Icon(Icons.person)),
          BottomNavigationBarItem(
            label: tr().tab_misc,
            icon: const Icon(
              Icons.miscellaneous_services,
            ),
          )
        ]);
  }
}

class Home extends StatelessWidget {
  const Home({Key? key, required this.settingsController}) : super(key: key);
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
                top: SizeConfig.screenHeight! * 0.0075,
                left: SizeConfig.screenWidth! * 0.05,
                right: SizeConfig.screenWidth! * 0.05),
            child: Text(tr().tab_home,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.screenWidth! * 0.1)),
          ),
          CustomAppBar(settingsController: settingsController),
          MovieHeader(
            settingsController: settingsController,
          ),
          Category(settingsController: settingsController),
          TrendingMovies(
            settingsController: settingsController,
          ),
        ],
      ),
    );
  }
}
