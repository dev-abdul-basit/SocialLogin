import 'package:firebase_database/firebase_database.dart';

import '../models/event_info.dart';
import '../models/notification_model.dart';

class Storage {
  Future<void> storeEventData(EventInfo eventInfo, String id) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child('Events')
        .child(id)
        .child('events')
        .child(eventInfo.id!);

    await databaseReference.update(eventInfo.toJson()).then((_) {
      // Data saved successfully!
      print('Data saved successfully');
    }).catchError((error) {
      // The write failed...
      print('Data not saved successfully');
    });
  }

  Future<void> deleteEvent(String id, String eventId) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child('Users')
        .child(id)
        .child('events')
        .child(eventId);
    await databaseReference.remove().then((_) {
      // Data saved successfully!
      print('Data saved successfully');
    }).catchError((error) {
      // The write failed...
    });
  }

//store noti data
  Future<void> storeNotiData(
      NotificationModel notificationModel, String id) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child('Notifications')
        .child(id)
        .child('noti')
        .child(notificationModel.id!);

    await databaseReference.update(notificationModel.toJson()).then((_) {
      // Data saved successfully!
      print('Noti saved successfully');
    }).catchError((error) {
      // The write failed...
      print('Noti not saved successfully');
    });
  }
}
