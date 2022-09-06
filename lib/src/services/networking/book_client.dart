import 'dart:convert';

import '../../models/book.dart';
import 'package:http/http.dart' as http;

import 'generic.dart';

class BookClient {
  Future<List<Book>> getBooks() async {
    List<Book> results = [];

    var response = await http.get(
        Uri.http(GenericClient.baseURL, '/parse/classes/Books'),
        headers: GenericClient.clHeaders);
    if (response.statusCode == 200) {
      var contemp = json.decode(response.body);
      contemp['results'].forEach((itor) => results.add(Book.fromJson(itor)));
    } else if (response.statusCode == 403) {
      results.add(BookError(isError: true));
    }
    return results;
  }
}
