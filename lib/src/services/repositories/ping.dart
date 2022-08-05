import '../networking.dart';

class PingRepository {
  static Future<bool> pingServer() async {
    return await PingClient.pingServer();
  }
}
