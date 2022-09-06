import 'dart:async';
import 'package:dio/dio.dart';

import 'generic.dart';

class PingClient {
  static Future<bool> pingServer() async {
    late bool isSuccess;
    var client = Dio();
    var ctoken = CancelToken();

    try {
      final response = await client
          .get('http://${GenericClient.baseURL}', cancelToken: ctoken)
          .timeout(const Duration(seconds: 10));

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
