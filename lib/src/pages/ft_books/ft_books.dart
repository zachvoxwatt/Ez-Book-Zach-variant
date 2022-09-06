import 'package:ez_book/src/blocs/ft_book/ft_book_bloc.dart';
import 'package:ez_book/src/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../size_config.dart';
import '../../models/book.dart';
import '../../settings/settings_controller.dart';
import 'widget/thumbnail.dart';

class FeaturedBooks extends StatelessWidget {
  const FeaturedBooks({Key? key, required this.settingsController})
      : super(key: key);
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    if (BlocProvider.of<BookBloc>(context).state is BookInitial) {
      context.read<BookBloc>().add(BookLoadEvent());
    }

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                bottom: MediaQuery.of(context).padding.bottom),
            width:
                SizeConfig.screenWidth! - (SizeConfig.screenWidth! * 2 * 0.04),
            height: SizeConfig.screenHeight! * 0.5,
            child: RefreshIndicator(
                onRefresh: () async {
                  return Future.delayed(const Duration(milliseconds: 100), () {
                    context.read<BookBloc>().add(BookLoadEvent());
                  });
                },
                child: SingleChildScrollView(
                    child: Column(children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                        top: SizeConfig.screenHeight! * 0.0075,
                        left: SizeConfig.screenWidth! * 0.05,
                        right: SizeConfig.screenWidth! * 0.05),
                    child: Text(tr().tab_ftb,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.screenWidth! * 0.1)),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.screenWidth! * 0.05,
                          right: SizeConfig.screenWidth! * 0.05,
                          bottom: SizeConfig.screenHeight! * 0.025),
                      alignment: Alignment.topLeft,
                      child: Text(
                        tr().ftb_tip,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      )),
                  BlocBuilder<BookBloc, BookState>(
                    builder: ((context, state) {
                      if (state is BookLoaded) {
                        return resultWidget(context, state.books);
                      }
                      if (state is BookErrorForbidden) {
                        return errorWidget(
                            context, tr().ftb_poll_err_forbidden);
                      }
                      if (state is BookErrorNoConnection) {
                        return errorWidget(
                            context, tr().ftb_poll_err_unreachable);
                      }
                      if (state is BookPollSuccess) {
                        return pollSuccessWidget(context);
                      }

                      return pollingWidget(context);
                    }),
                  )
                ])))));
  }

  Container resultWidget(BuildContext context, List<Book> bookList) {
    return Container(
        margin: EdgeInsets.only(
            bottom: SizeConfig.screenHeight! * 0.05,
            right: SizeConfig.screenWidth! * 0.025,
            left: SizeConfig.screenWidth! * 0.025),
        child: (ListView.builder(
            padding: const EdgeInsets.only(top: 0),
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: bookList.length,
            itemBuilder: ((context, indx) {
              return BookThumbnail(
                book: bookList[indx],
                settingsController: settingsController,
              );
            }))));
  }

  Container pollingWidget(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return Container(
        margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.3),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            Container(
                margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.0125),
                child: Text(tr().ftb_poll_polling))
          ],
        ));
  }

  Container pollSuccessWidget(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return Container(
      margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.295),
      child: Column(children: [
        Text('✅', style: TextStyle(fontSize: SizeConfig.fsize(0.0875))),
        Container(
            margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.0125),
            child: Text(tr().ftb_poll_success))
      ]),
    );
  }

  Container errorWidget(BuildContext context, String msg) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return Container(
        margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.3),
        child: Column(
          children: [
            Text(
              msg,
              style: TextStyle(fontSize: SizeConfig.fsize(0.05)),
              textAlign: TextAlign.center,
            ),
            Container(
                margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.0125),
                child: ElevatedButton(
                  child: Text(tr().ftb_poll_retry),
                  onPressed: () {
                    context.read<BookBloc>().add(BookLoadEvent());
                  },
                ))
          ],
        ));
  }
}
