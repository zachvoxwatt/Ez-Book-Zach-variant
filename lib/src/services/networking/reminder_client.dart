import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../models/reminder.dart';
import 'generic.dart';

class ReminderClient {
  Future<List<Reminder>> getReminders(requiredInfo) async {
    List<Reminder> results = [];

    var response = await http.get(
        Uri.http(GenericClient.baseURL, '/parse/classes/Reminders'),
        headers: GenericClient.clHeaders);

    if (response.statusCode == 200) {
      var contemp = json.decode(response.body);

      if (contemp['results'].isEmpty) {
        results = [];
      } else {
        contemp['results'].forEach((itor) {
          if (itor['ownerId'] == requiredInfo['objectId']) {
            results.add(Reminder.fromJson(itor));
          }
        });
      }
    }

    return results;
  }

  Future<ReminderResult> postReminder(datagram) async {
    late ReminderResult returner;
    var response = await http.post(
        Uri.http(GenericClient.baseURL, '/parse/classes/Reminders'),
        body: json.encode(datagram),
        headers: GenericClient.clHeaders);

    if (response.statusCode == 201) {
      returner = ReminderResult(isSuccess: true);
    } else if (response.statusCode == 400) {
      returner = ReminderResult(
          isSuccess: false,
          errorMessage: 'An error occurred. Please try again!');
    }

    return returner;
  }

  Future<void> markReminder(reminderId, isCompleted) async {
    var markStatus = {'isCompleted': isCompleted};

    await http.put(
        Uri.http(GenericClient.baseURL, '/parse/classes/Reminders/$reminderId'),
        body: json.encode(markStatus),
        headers: GenericClient.clHeaders);
  }

  Future<void> updateReminder(requiredInfo, datagram) async {
    await http.put(
        Uri.http(GenericClient.baseURL,
            '/parse/classes/Reminders/${requiredInfo['objectId']}'),
        body: json.encode(datagram),
        headers: GenericClient.clHeaders);
  }

  Future<void> deleteReminder(reminderId) async {
    await http.delete(
        Uri.http(GenericClient.baseURL, '/parse/classes/Reminders/$reminderId'),
        headers: GenericClient.clHeaders);
  }
}
