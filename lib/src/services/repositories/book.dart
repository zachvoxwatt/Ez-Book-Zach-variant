import 'package:ez_book/src/models/book.dart';

import '../networking.dart';

class BookRepository {
  final BookClient bookcl;

  BookRepository({required this.bookcl});

  Future<List<Book>> getBooks() async {
    return await bookcl.getBooks();
  }
}
