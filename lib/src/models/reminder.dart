import 'package:intl/intl.dart';

class Reminder {
  final String reminderId, ownerId;
  bool isCompleted;
  String? bookId, content, doneTime;

  Reminder(
      {this.bookId,
      this.content,
      this.doneTime,
      required this.isCompleted,
      required this.reminderId,
      required this.ownerId});
  void markCompleted() {
    isCompleted = true;
  }

  void markIncompleted() {
    isCompleted = false;
  }

  static final remList = [
    Reminder(
        isCompleted: false,
        content:
            'this is a long ass reminder to test out padding and margin of Ez Book app reminder card widget hehehheheheheh',
        reminderId: 'lololol',
        ownerId: 'yareyaredaze',
        doneTime: '17/08/2022 @11:40'),
    Reminder(
        isCompleted: false,
        reminderId: 'abc',
        ownerId: '123',
        content: 'Read a book',
        doneTime: '20/08/2022 @12:00'),
    Reminder(
        isCompleted: false,
        reminderId: 'abc1',
        ownerId: '1234',
        content: 'Take the laundry and read a book',
        doneTime: '20/08/2022 @16:00'),
    Reminder(
        isCompleted: false,
        reminderId: 'abc2',
        ownerId: '12345',
        doneTime: '20/08/2022 @19:00'),
    Reminder(
        isCompleted: false,
        reminderId: 'abc3',
        ownerId: '123456',
        content: 'Lorem ipsum dolor sit',
        doneTime: '21/08/2022 @09:30'),
    Reminder(
        isCompleted: false,
        reminderId: 'abc4',
        ownerId: '1234567',
        content: 'Read a book',
        doneTime: '21/08/2022 @15:45'),
    Reminder(
        isCompleted: false,
        reminderId: 'abc5',
        ownerId: '12345678',
        doneTime: '21/08/2022 @21:00'),
  ];

  factory Reminder.fromJson(Map<String, dynamic> parsedJson) {
    return Reminder(
        isCompleted: parsedJson['isCompleted'] as bool,
        ownerId: parsedJson['ownerId'],
        reminderId: parsedJson['objectId'],
        bookId: parsedJson['bookId'],
        content: parsedJson['content'],
        doneTime: parsedJson['doneTime'].toString());
  }

  static String formatDate(DateTime dt) {
    var dateFormat = DateFormat('dd/MM/yyyy, HH:mm');
    return dateFormat.format(dt);
  }
}

class ReminderResult {
  final bool isSuccess;
  String? errorMessage;

  ReminderResult({this.errorMessage, required this.isSuccess});
}
