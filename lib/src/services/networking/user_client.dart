import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../models/user.dart';
import 'generic.dart';

class UserClient {
  Future<User> getUser(requiredInfo, additionalInfo) async {
    late User returner;

    var sentHeaders = GenericClient.cloneHeaders();

    if (additionalInfo['sessionToken'] != null) {
      sentHeaders['X-Parse-Session-Token'] = additionalInfo['sessionToken'];
    }
    var response = await http.get(
        Uri.http(
            GenericClient.baseURL, '/parse/users/${requiredInfo['objectId']!}'),
        headers: sentHeaders);

    if (response.statusCode == 404) {
      throw Exception('User not found');
    }

    if (response.statusCode == 200) {
      var contemp = json.decode(response.body);

      additionalInfo['sessionToken'] == null
          ? contemp['sessionToken'] = requiredInfo['sessionToken']
          : contemp['sessionToken'] = additionalInfo['sessionToken'];

      returner = User.fromJson(contemp);
    }

    return returner;
  }

  Future<User> register(datagram) async {
    late User returner;
    var response = await http.post(
        Uri.http(GenericClient.baseURL, '/parse/users'),
        body: json.encode(datagram),
        headers: GenericClient.clHeaders);

    if (response.statusCode == 201) {
      returner = UserAccountRegistrySuccessModel();
    } else if (response.statusCode == 400) {
      var contemp = json.decode(response.body);
      returner = UserAccountRegistryErrorModel(
          errorCode: contemp['code'], error: contemp['error']);
    }

    return returner;
  }

  Future<User> signin(datagram) async {
    late User returner;

    var response = await http.post(
        Uri.http(GenericClient.baseURL, '/parse/login'),
        body: json.encode(datagram),
        headers: GenericClient.clHeaders);

    var contemp = json.decode(response.body);
    if (response.statusCode == 200) {
      returner = User.fromJson(contemp);

//If a user has many sessions
//which are not expired yet,
//this function is used to
//invalidate all of them
//      --------------------
//
//               |
//               |
//               |
//               V

      invalidateExistingSessions(contemp);
    } else {
      returner = UserAccountSignInErrorModel(errorCode: contemp['code']);
    }

    return returner;
  }

  Future<void> signout(requiredInfo) async {
    var signoutHeaders = GenericClient.cloneHeaders();
    invalidateExistingSessions({'sessionToken': requiredInfo['sessionToken']});

    signoutHeaders['X-Parse-Session-Token'] = requiredInfo['sessionToken'];
    await http.post(Uri.http(GenericClient.baseURL, '/parse/logout'),
        headers: signoutHeaders);
  }

  Future<User> update(requiredInfo, toBeChanged) async {
    late User returner;
    var updateHeaders = GenericClient.cloneHeaders();
    updateHeaders['X-Parse-Session-Token'] = requiredInfo['sessionToken']!;

    var response = await http.put(
        Uri.http(
            GenericClient.baseURL, '/parse/users/${requiredInfo['objectId']!}'),
        body: json.encode(toBeChanged),
        headers: updateHeaders);

    var contemp = json.decode(response.body);

    if (response.statusCode == 200) {
      var additionalInfo = {};
      if (contemp['sessionToken'] != null) {
        additionalInfo['sessionToken'] = contemp['sessionToken'];
      }
      returner = UserAccountEditSuccessModel(
          user: await getUser(requiredInfo, additionalInfo));
    }

    if (response.statusCode == 400) {
      returner = UserAccountEditFailedModel(errorCode: contemp['code']);
    }

    return returner;
  }

  Future<bool> delete(requiredInfo) async {
    bool success = false;
    var updateHeaders = GenericClient.cloneHeaders();
    updateHeaders['X-Parse-Session-Token'] = requiredInfo['sessionToken']!;

    var response = await http.delete(
        Uri.http(
            GenericClient.baseURL, '/parse/users/${requiredInfo['objectId']!}'),
        headers: updateHeaders);

    if (response.statusCode == 200) {
      success = true;
    }

    invalidateAllSessions({'sessionToken': requiredInfo['sessionToken']});

    return success;
  }
}

void invalidateExistingSessions(datagram) async {
  var sessionGetterHeaders = GenericClient.cloneHeaders();
  sessionGetterHeaders['X-Parse-Session-Token'] = datagram['sessionToken'];

  var existingSessions = await http.get(
      Uri.http(GenericClient.baseURL, '/parse/sessions'),
      headers: sessionGetterHeaders);

  var parsed = json.decode(existingSessions.body);
  var listOfSessions = parsed['results'];

  if (listOfSessions.length != 1) {
    listOfSessions.forEach((itor) async {
      if (itor['sessionToken'] != datagram['sessionToken']) {
        await http.delete(
            Uri.http(
                GenericClient.baseURL, '/parse/sessions/${itor['objectId']}'),
            headers: sessionGetterHeaders);
      }
    });
  }
}

void invalidateAllSessions(datagram) async {
  var sessionGetterHeaders = GenericClient.cloneHeaders();
  sessionGetterHeaders['X-Parse-Session-Token'] = datagram['sessionToken'];

  var existingSessions = await http.get(
      Uri.http(GenericClient.baseURL, '/parse/sessions'),
      headers: sessionGetterHeaders);

  var parsed = json.decode(existingSessions.body);
  var listOfSessions = parsed['results'];

  listOfSessions.forEach((itor) async {
    await http.delete(
        Uri.http(GenericClient.baseURL, '/parse/sessions/${itor['objectId']}'),
        headers: sessionGetterHeaders);
  });
}
