import 'package:firebase_database/firebase_database.dart';

class EventInfo {
   String? id;
    late String name;
    late String description;
    late String location;
    late String link;
    late String date;
    late List<dynamic> attendeeEmails;
    late bool shouldNotifyAttendees;
    late bool hasConfereningSupport;
    late int startTimeInEpoch;
    late int endTimeInEpoch;
    late String status;

  EventInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.link,
    required this.date,
    required this.attendeeEmails,
    required this.shouldNotifyAttendees,
    required this.hasConfereningSupport,
    required this.startTimeInEpoch,
    required this.endTimeInEpoch,
    required this.status,
  });

  //constructor for add
   EventInfo.withId(
      this.id,
      this.name,
      this.description,
      this.location,
      this.link,
      this.date,
      this.attendeeEmails,
      this.shouldNotifyAttendees,
      this.hasConfereningSupport,
      this.startTimeInEpoch,
      this.endTimeInEpoch,
       this.status
   );

   //getters
   String? get getId => id;
   String get getName => name;
   String get getDesc => description;
   String get getLocation => location;
   String get getLink => link;
   String get getDate => date;
   List get getAttendeeEmails => attendeeEmails;
   bool get getNotifyAttendee => shouldNotifyAttendees;
   bool get getConferencingSupport => hasConfereningSupport;
   int get getStartTime => startTimeInEpoch;
   int get getEndTime => endTimeInEpoch;
   String get getStatus => status;



  EventInfo.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    id = (snapshot.value as dynamic)["id"];
    name =(snapshot.value as dynamic)['name'] ;
    description =(snapshot.value as dynamic)['desc'];
    location = (snapshot.value as dynamic)['loc'];
    link = (snapshot.value as dynamic)['link'];
    date = (snapshot.value as dynamic)['date'];
    attendeeEmails = (snapshot.value as dynamic)['emails'] ;
    shouldNotifyAttendees = (snapshot.value as dynamic)['should_notify'];
    hasConfereningSupport = (snapshot.value as dynamic)['has_conferencing'];
    startTimeInEpoch = (snapshot.value as dynamic)['start'];
    endTimeInEpoch = (snapshot.value as dynamic)['end'];
    status = (snapshot.value as dynamic)['status'];
    }
//Converting class object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'desc': description,
      'loc': location,
      'link': link,
      'date': date,
      'emails': attendeeEmails,
      'should_notify': shouldNotifyAttendees,
      'has_conferencing': hasConfereningSupport,
      'start': startTimeInEpoch,
      'end': endTimeInEpoch,
      'status':status,
    };
  }
}
