class GenericClient {
  static const baseURL = '192.168.10.30:1337';
//  static const baseURL = '192.168.0.100:1337';
  static final clHeaders = {
    'X-Parse-Application-Id': 'myAppId',
    'X-Parse-Revocable-Session': '1',
    'Content-Type': 'application/json'
  };

  static Map<String, String> cloneHeaders() {
    return Map.from(clHeaders);
  }
}
