import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:ez_book/src/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/book.dart';
import '../../detail/detail.dart';

class BookThumbnail extends StatelessWidget {
  const BookThumbnail(
      {Key? k, required this.book, required this.settingsController})
      : super(key: k);
  final Book book;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr() {
      return AppLocalizations.of(context)!;
    }

    return GestureDetector(
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailPage(
                  settingsController: settingsController,
                  tappedBook: book,
                  isLocal: false,
                ),
              ),
            ),
        child: Container(
          margin: EdgeInsets.only(
              top: SizeConfig.screenHeight! * 0.01,
              left: SizeConfig.screenWidth! * 0.0375,
              bottom: SizeConfig.screenHeight! * 0.01,
              right: SizeConfig.screenWidth! * 0.0375),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
                width: SizeConfig.screenWidth! * 0.25,
                height: SizeConfig.screenHeight! * 0.175,
                child: Image.network(book.imgUrl!)),
            Flexible(
                child: Container(
                    margin:
                        EdgeInsets.only(left: SizeConfig.screenWidth! * 0.0375),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${book.name}',
                            style: TextStyle(
                                fontSize: SizeConfig.fsize(0.05),
                                fontWeight: FontWeight.bold),
                          ),
                          Text('${book.auther}',
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic)),
                          Container(
                              margin: EdgeInsets.only(
                                  top: SizeConfig.screenHeight! * 0.02),
                              child: Text(
                                '${tr().ftb_book_genre}: ${book.type!.join(', ')}',
                                style: TextStyle(
                                    color: settingsController.themeMode ==
                                            ThemeMode.dark
                                        ? const Color(0xff90EE90)
                                        : const Color(0xff228B22)),
                              ))
                        ]))),
          ]),
        ));
  }
}
