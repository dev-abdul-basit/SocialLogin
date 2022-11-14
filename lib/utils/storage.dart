
import 'package:firebase_database/firebase_database.dart';
import '../models/event_info.dart';


class Storage {
  Future<void> storeEventData(EventInfo eventInfo,String id) async {

    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('Users').child(id).child('events').child(eventInfo.id!);

    Map<String, dynamic> data = eventInfo.toJson();

    print('DATA:\n$data');

    await databaseReference.update(eventInfo.toJson()).whenComplete(() {
      print("Event added to the database, id: {${eventInfo.id}}");
    }).catchError((e) => print(e));
  }


}
