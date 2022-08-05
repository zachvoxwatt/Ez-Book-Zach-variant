// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../models/book.dart';
import '../models/user.dart';

const _baseURL = '192.168.10.30:1337';
final clHeaders = {
  'X-Parse-Application-Id': 'myAppId',
  'Content-Type': 'application/json'
};

class PingClient {
  static Future<bool> pingServer() async {
    late bool isSuccess;
    var client = Dio();
    var ctoken = CancelToken();

    try {
      final response = await client
          .get('http://$_baseURL', cancelToken: ctoken)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        isSuccess = true;
      } else {
        isSuccess = false;
      }
    } on TimeoutException catch (_) {
      isSuccess = false;
      ctoken.cancel();
    } finally {
      client.close(force: true);
    }

    return isSuccess;
  }
}

class BookClient {
  Future<List<Book>> getBooks() async {
    List<Book> results = [];

    var response = await http.get(Uri.http(_baseURL, '/parse/classes/Books'),
        headers: clHeaders);
    if (response.statusCode == 200) {
      var contemp = json.decode(response.body);
      contemp['results'].forEach((itor) => results.add(Book.fromJson(itor)));
    } else if (response.statusCode == 403) {
      results.add(BookError(isError: true));
    }
    return results;
  }
}

class UserClient {
  Future<User> getUser(datagram) async {
    // late User result;

    // var response = await http.post(Uri.http(_baseURL, '/parse/users'),
    //     body: datagram, headers: clHeaders);

    return User.userlist[1];
  }

  Future<User> register(datagram) async {
    late User returner;
    var response = await http.post(Uri.http(_baseURL, '/parse/users'),
        body: json.encode(datagram), headers: clHeaders);

    if (response.statusCode == 201) {
      returner = UserAccountRegistrySuccessModel();
    } else if (response.statusCode == 400) {
      var contemp = json.decode(response.body);

      returner = UserAccountRegistryErrorModel(error: contemp['error']);
    }

    return returner;
  }

  Future<User> signin(datagram) async {
    late User returner;

    var response = await http.post(Uri.http(_baseURL, '/parse/login'),
        body: json.encode(datagram), headers: clHeaders);

    var contemp = json.decode(response.body);
    if (response.statusCode == 200) {
      returner = User.fromJson(contemp);
    } else {
      returner = UserAccountSignInErrorModel(errorMessage: contemp['error']);
    }

    return returner;
  }
}
