import 'package:com.invoseg.innovation/Screens/Discounts/discountDetails.dart';
import 'package:com.invoseg.innovation/Screens/E-Reciept.dart';
import 'package:com.invoseg.innovation/Screens/Prescription.dart';
import 'package:com.invoseg.innovation/Screens/Tab.dart';
import 'package:com.invoseg.innovation/Screens/plots_detail.dart';
import 'package:com.invoseg.innovation/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  String FCMtoken = "";
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> inNotify() async {
    await firebaseMessaging.requestPermission();

    getMobileToken();
    initNotify();
  }

  getMobileToken() {
    firebaseMessaging.getToken().then((String? token) {
      if (token != null) {
        FCMtoken = token;

        // print("FCM Token: $FCMtoken");
      } else {
        // print("Unable to get FCM token");
      }
    });
  }

  RemoteMessage? message1;
  void handleMessage(RemoteMessage? message) {
    if (message != null) {
      print("if working in handle message ");
      message1 = message;
      String? title = message1!.notification!.title;
      String? body = message1!.notification!.body;
      print("Title = $title");
      print("Body = $body");
      if (title.toString().contains("Complain")) {
        navigatorKey.currentState?.pushNamed('/complaint', arguments: message1);
      } else if (title.toString() == "Order Completed") {
        var data = message1!.data['documentId'];
        print("disajdisjdiajidjsa" + data);
        navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) =>
                ViewEReciept(value: true, id: data, status: "Processing")));
      } else if (title.toString() == "Order Updated") {
        var data = message1!.data['documentId'];
        print("disajdisjdiajidjsa" + data);
        navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) =>
                ViewEReciept(value: false, id: data, status: "Delivered")));
      } else if (title.toString().contains("Link Generated")) {
        print("firebase API `Message = ${message1!.notification!.title}");
        navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => TabsScreen(index: 2)));
      } else if (title.toString().contains("Prescription")) {
        var data = message1!.data['documentId'];
        print("DATATATATATATATATATATATATATATATATATA" + data ?? 'null');
        print("firebase API `Message = ${message1!.notification!.title}");
        print("firebase API `Message = $data");
        navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => Prescription(
                  id: data,
                )));
      } else if (title.toString().contains('post')) {
        navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => TabsScreen(
                  index: 3,
                )));
      } else if (body.toString().contains('Discounts')) {
        var data = message1!.data['documentId'];
        print("data=========$data");
        navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => DiscountDetails(
                  ids: data,
                )));
      } else if (body.toString().contains('plot')) {
        var data = message1!.data['documentId'];
        print('DAtatatata===$data');
        navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => PlotsDetail(ids: data)));
      }
      print("Moved");
    } else {
      print("else working in handle message and is null");
    }
  }

  Future initNotify() async {
    // FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
