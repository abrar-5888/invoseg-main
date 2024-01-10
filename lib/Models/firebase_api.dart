import 'package:com.invoseg.innovation/Screens/main/E-Reciept.dart';
import 'package:com.invoseg.innovation/Screens/main/Prescription.dart';
import 'package:com.invoseg.innovation/Screens/main/Tab.dart';
import 'package:com.invoseg.innovation/global.dart';
import 'package:com.invoseg.innovation/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NamedFirebaseMessaging {
  final FirebaseApp name;
  final FirebaseMessaging _firebaseMessaging;

  NamedFirebaseMessaging(this.name)
      : _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> requestPermission() async {
    await _firebaseMessaging.requestPermission();
  }

  Future<String?> getToken() async {
    FirebaseApp secondaryApp = Firebase.app('CMS-All');
    // print(secondaryApp);
    String? secondaryAppToken = await FirebaseMessaging.instance.getToken(
        // vapidKey: secondaryApp.options.apiKey,
        ); // Use
    return secondaryAppToken;
  }

  // Other methods you want to expose, e.g., configure, subscribe, etc.

  // Example: listen to onMessageOpenedApp
  void listenToOnMessageOpenedApp(void Function(RemoteMessage) callback) {
    FirebaseMessaging.onMessageOpenedApp.listen(callback);
  }

  Future main1() async {
    NamedFirebaseMessaging secondaryFirebaseMessaging =
        NamedFirebaseMessaging(secondApp);
    // NamedFirebaseMessaging mainFirebaseMessaging = NamedFirebaseMessaging('main');
    // NamedFirebaseMessaging secondaryFirebaseMessaging = NamedFirebaseMessaging('secondary');

    // await mainFirebaseMessaging.requestPermission();
    await secondaryFirebaseMessaging.requestPermission();

    // String? mainToken = await mainFirebaseMessaging.getToken();
    String? secondaryToken = await secondaryFirebaseMessaging.getToken();

    // print('Main FCM Token: $mainToken');
    print('Secondary FCM Token test: $secondaryToken');

    // mainFirebaseMessaging.listenToOnMessageOpenedApp((message) {
    //   print('Main FCM Message: $message');
    // });

    secondaryFirebaseMessaging.listenToOnMessageOpenedApp((message) {
      print('Secondary FCM Message: $message');
    });
  }
}

class FirebaseApi {
  String FCMtoken = "";
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // final FirebaseMessaging firebaseMessagingSecondary =
  //     FirebaseMessaging.instance.;
  // NamedFirebaseMessaging mainFirebaseMessaging = NamedFirebaseMessaging('main');

  Future<void> inNotify() async {
    await firebaseMessaging.requestPermission();

    getMobileToken();
    initNotify();
    NamedFirebaseMessaging(secondApp).main1();
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
      print("if working in handle message ${secondApp.options.apiKey}");
      message1 = message;
      String? title = message1!.notification!.title;
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
      } else if (title.toString().contains("Link")) {
        print("firebase API `Message = ${message1!.notification!.title}");
        navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => TabsScreen(index: 2)));
      } else if (title.toString().contains("Prescription")) {
        var data = message1!.data['documentId'];
        print(data);
        print("firebase API `Message = ${message1!.notification!.title}");
        print("firebase API `Message = $data");
        navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => Prescription(
                  id: data,
                )));
      }
      print("Moved");
    } else {
      print("else working in handle message ");
    }
  }

  Future initNotify() async {
    // FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
