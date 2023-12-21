import 'package:com.invoseg.innovation/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  String FCMtoken = "";
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // final FirebaseMessaging firebaseMessaging2=FirebaseMessaging.instanceFor(app:secondApp);

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
      message1 = message;
      // print("firebase API `Message = $message1");
      navigatorKey.currentState
          ?.pushNamed('/notification', arguments: message1);
    } else {}
  }

  Future initNotify() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
