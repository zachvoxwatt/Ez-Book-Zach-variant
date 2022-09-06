import 'package:ez_book/src/models/book.dart';

import '../networking/book_client.dart';

class BookRepository {
  final BookClient bookcl;

  BookRepository({required this.bookcl});

  Future<List<Book>> getBooks() async {
    return await bookcl.getBooks();
  }
}
