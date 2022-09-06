import 'package:ez_book/src/models/reminder.dart';

import '../networking/reminder_client.dart';

class ReminderRepository {
  final ReminderClient remcl;

  ReminderRepository({required this.remcl});

  Future<List<Reminder>> getReminders(requiredInfo) async {
    return await remcl.getReminders(requiredInfo);
  }

  Future<ReminderResult> postReminder(datagram) async {
    return await remcl.postReminder(datagram);
  }

  Future<void> markReminder(reminderId, isCompleted) async {
    return await remcl.markReminder(reminderId, isCompleted);
  }

  Future<void> updateReminder(requiredInfo, datagram) async {
    return await remcl.updateReminder(requiredInfo, datagram);
  }

  Future<void> deleteReminder(reminderId) async {
    return await remcl.deleteReminder(reminderId);
  }
}
