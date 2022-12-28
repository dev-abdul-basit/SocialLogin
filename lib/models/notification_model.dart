import 'package:firebase_database/firebase_database.dart';

class NotificationModel {
  String? _id;
  late String _notiTitle;
  late String _notiDescription;
  late String _date;
  late String _time;
  late bool _viewed;
  late String _status;
  late String _token;

  //constructor for add
  NotificationModel(
    this._notiTitle,
    this._notiDescription,
    this._date,
    this._time,
    this._viewed,
    this._status,
    this._token,
  );

  //Constructor for edit
  NotificationModel.withId(
    this._id,
    this._notiTitle,
    this._notiDescription,
    this._date,
    this._time,
    this._viewed,
    this._status,
    this._token,
  );

  //getters
  String? get id => _id;
  String get notiTitle => _notiTitle;
  String get notiDesc => _notiDescription;
  String get date => _date;
  String get time => _time;
  bool get viewed => _viewed;

  String get status => _status;
  String get token => _token;

  //Setters

  set isViewed(bool status) {
    _viewed = status;
  }

//Converting snapshot back to class object
  NotificationModel.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _id = (snapshot.value as dynamic)["id"];
    _notiTitle = (snapshot.value as dynamic)["notiTitle"];
    _notiDescription = (snapshot.value as dynamic)["notiDescription"];
    _date = (snapshot.value as dynamic)["date"];
    _time = (snapshot.value as dynamic)["time"];
    _viewed = (snapshot.value as dynamic)["viewed"];

    _status = (snapshot.value as dynamic)["status"];
    _token = (snapshot.value as dynamic)["token"];
  }

//Converting class object to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": _id,
      "notiTitle": _notiTitle,
      "notiDescription": _notiDescription,
      "date": _date,
      "time": _time,
      "viewed": _viewed,
      "status": _status,
      "token": _token,
    };
  }
}
