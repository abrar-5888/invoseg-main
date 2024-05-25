import 'package:firebase_messaging/firebase_messaging.dart';
// ignore_for_file: file_names

Future<String> getMobileToken() async {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String? token = await firebaseMessaging.getToken();
  if (token != null) {
    return token;
  } else {
    return '';
  }
}
