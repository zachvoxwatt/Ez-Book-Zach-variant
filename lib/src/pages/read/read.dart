import 'package:ez_book/src/blocs/display_settings/display_settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ez_book/src/models/book.dart';
import 'package:ez_book/src/pages/read/widget/bottom_sheet.dart';
import 'package:ez_book/src/settings/settings_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadPage extends StatefulWidget {
  const ReadPage(
      {Key? key, required this.selectedBook, required this.settingsController})
      : super(key: key);
  final SettingsController settingsController;
  final Book selectedBook;

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    var dispState = BlocProvider.of<DisplaySettingsBloc>(context).state;
    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        show == true ? show = false : show = true;
                      });
                    },
                    icon: const Icon(Icons.more_vert)),
                const SizedBox(
                  width: 12,
                ),
              ],
              floating: true,
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.selectedBook.name.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(widget.selectedBook.auther.toString(),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Roboto')),
                ],
              ),
            ),
            _buildContent(context),
          ],
        ),
      ),
      bottomSheet: show == true
          ? BottomSheet(
              enableDrag: false,
              builder: (context) => BottomSheetWidget(
                settingsController: widget.settingsController,
                settings: {
                  'size': dispState.fontSize,
                  'theme': widget.settingsController.themeMode == ThemeMode.dark
                      ? true
                      : false,
                  'font_name': dispState.fontFamily,
                },
                onClickedClose: () => setState(() {
                  show = false;
                }),
                onClickedConfirm: (value) => setState(() {
                  show = false;
                }),
              ),
              onClosing: () {},
            )
          : null,
    );
  }

  Widget _buildContent(BuildContext context) {
    var dispState = BlocProvider.of<DisplaySettingsBloc>(context).state;

    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.selectedBook.content.toString(),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: dispState.fontSize,
                  fontFamily: dispState.fontFamily),
            ),
          )
        ],
      ),
    );
  }
}
