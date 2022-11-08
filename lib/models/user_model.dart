import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? _id;
  late String _userName;
  late String _password;
  late String _phone;
  late String _email;
  late String _address;
  late String _photoUrl;
  late String _status;
  late String _token;

  //constructor for add
  UserModel(
    this._userName,
    this._password,
    this._phone,
    this._email,
    this._address,
    this._photoUrl,
    this._status,
    this._token,
  );

  //Constructor for edit
  UserModel.withId(
    this._id,
    this._userName,
    this._password,
    this._phone,
    this._email,
    this._address,
    this._photoUrl,
    this._status,
    this._token,
  );
  //Constructor for edit without password
  UserModel.editwithId(
    this._id,
    this._userName,

    this._phone,
    this._email,
    this._address,
    this._photoUrl,
    this._status,
    this._token,
  );

  //getters
  String? get id => _id;
  String get userName => _userName;
  String get password => _password;
  String get phone => _phone;
  String get email => _email;
  String get address => _address;
  String get photoUrl => _photoUrl;
  String get status => _status;
  String get token => _token;

  //Setters
  set setFirstName(String firstName) {
    _userName = firstName;
  }

  set setPassword(String password) {
    _password = password;
  }

  set setPhone(String phone) {
    _phone = phone;
  }

  set setEmail(String email) {
    _email = email;
  }

  set setAdress(String adress) {
    _address = adress;
  }

  set setPhotoUrl(String photoUrl) {
    _photoUrl = photoUrl;
  }

  set setStatus(String status) {
    _status = status;
  }

  set setToken(String token) {
    _token = token;
  }

//Converting snapshot back to class object
  UserModel.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _id = (snapshot.value as dynamic)["id"];
    _userName = (snapshot.value as dynamic)["userName"];
    _password = (snapshot.value as dynamic)["password"];
    _phone = (snapshot.value as dynamic)["phone"];
    _email = (snapshot.value as dynamic)["email"];
    _address = (snapshot.value as dynamic)["address"];
    _photoUrl = (snapshot.value as dynamic)["photoUrl"];
    _status = (snapshot.value as dynamic)["status"];
    _token = (snapshot.value as dynamic)["token"];
  }

//Converting class object to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": _id,
      "userName": _userName,
      "password": _password,
      "phone": _phone,
      "email": _email,
      "address": _address,
      "photoUrl": _photoUrl,
      "status": _status,
      "token": _token,
    };
  }

//Converting class object to JSON
  Map<String, dynamic> toJsonEdit() {
    return {
      "id": _id,
      "userName": _userName,

      "phone": _phone,
      "email": _email,
      "address": _address,
      "photourl": _photoUrl,
      "status": _status,
      "token": _token,
    };
  }
}
