library config.globals;

import 'dart:convert';

import 'package:http/http.dart' as http;

class SendPushMessage {
  void sendPushNotification(String title, String body, String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'AAAAFsrGLzo:APA91bE_PIG2GRewAMxfeSfMAafPrGSvG6TzValkwDqJjA9lYm6NiYkTa-GU-_mvEpM8LmgKsEgmMGgA1AoISfDpOj7zd-s5ATcKecZ5wcRseo3567rLPst5PcvkD29-r88T3j8H-MQZ',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      print('done');
    } catch (e) {
      print("error push notification");
    }
  }
}
