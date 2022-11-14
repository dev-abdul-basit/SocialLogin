import 'dart:io' show Platform;

class Secret {
  static const ANDROID_CLIENT_ID = "97891266362-qpqh8l0d12fk7hbljf4pd06pmosipg5n.apps.googleusercontent.com";
  static const IOS_CLIENT_ID = "97891266362-jfap4m14nr7v5m960i5cbod08ksv36qe.apps.googleusercontent.com";
  static String getId() => Platform.isAndroid ? Secret.ANDROID_CLIENT_ID : Secret.IOS_CLIENT_ID;
}