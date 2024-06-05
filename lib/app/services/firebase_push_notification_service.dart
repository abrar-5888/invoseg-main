// ignore_for_file: avoid_print, unused_local_variable

import 'package:com.invoseg.innovation/app/Modules/notifications/notifications_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

// ignore_for_file: non_constant_identifier_names

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
      FCMtoken = token!;
    });
  }

  RemoteMessage? message1;
  void handleMessage(RemoteMessage? message) {
    NotificationsController controller = Get.find<NotificationsController>();
    if (message != null) {
      message1 = message;
      String? title = message1!.notification!.title;
      String? body = message1!.notification!.body;
      // if (title.toString().toLowerCase().contains("complain")) {
      //   navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => const ComplainPage()));
      // } else if (title.toString().toLowerCase() == "order completed") {
      //   var data = message1!.data['documentId'];
      //   controller.moveToRecipt(data);
      // } else if (title.toString().toLowerCase().contains("link generated")) {
      //   navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => const MainPage(index: 3)));
      // } else if (title.toString().toLowerCase().contains("prescription")) {
      //   var data = message1!.data['documentId'];
      //   controller.moveToPrescription(data);
      // } else if (title.toString().toLowerCase().contains('post')) {
      //   print('oka');
      //   navigatorKey.currentState?.push(MaterialPageRoute(
      //       builder: (context) => const MainPage(
      //             index: 1,
      //           )));
      // } else if (body.toString().contains('plot')) {
      //   navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => const MainPage(index: 4)));
      // }
    } else {}
  }

  Future initNotify() async {
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
