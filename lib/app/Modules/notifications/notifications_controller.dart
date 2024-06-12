import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/app/Modules/e_recipt/e_reciept_view.dart';
import 'package:com.invoseg.innovation/app/data/Models/notificationModel.dart';
import 'package:com.invoseg.innovation/app/data/api/firebaseNodes.dart';
import 'package:com.invoseg.innovation/utils/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
// ignore_for_file: avoid_print

class NotificationsController extends GetxController {
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();

    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      FirebaseFirestore.instance.collection(FirebaseNodes.NOTIFICATIONS).where('uid', isEqualTo: userId).snapshots().listen((event) {
        notifications.value = event.docs.map((e) => NotificationModel.fromJson(e.data())).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  void moveToRecipt(String id) async {
    Get.to(() => Receipt(id: id));
  }

  void moveToPrescription(String id) async {
    // Get.to(() => Prescription(medical: medical));
  }
}
