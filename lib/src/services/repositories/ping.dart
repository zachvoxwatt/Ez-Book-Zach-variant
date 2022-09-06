import '../networking/ping_client.dart';

class PingRepository {
  static Future<bool> pingServer() async {
    return await PingClient.pingServer();
  }
}
