import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:com.invoseg.innovation/app/Modules/e_recipt/e_reciept_view.dart';
import 'package:com.invoseg.innovation/app/Modules/prescription/prescription.dart';
import 'package:com.invoseg.innovation/data/Models/groceryModel.dart';
import 'package:com.invoseg.innovation/data/Models/medicalModel.dart';
import 'package:com.invoseg.innovation/data/Models/notificationModel.dart';
import 'package:com.invoseg.innovation/data/api/groceryApi.dart';
import 'package:com.invoseg.innovation/data/api/medicalApi.dart';
import 'package:com.invoseg.innovation/data/api/notificationsApi.dart';
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
      NotificationsApi.notificationQuery.where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots().listen((event) {
        notifications.value = event.docs.map((e) => NotificationModel.fromJson(e.data())).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  void moveToRecipt(String id) async {
    DocumentSnapshot querySnapshot = await GroceryApi.groceryRef.doc(id).get();
    GroceryModel grocery = GroceryModel.fromJson(querySnapshot.data()! as Map<String, dynamic>);

    Get.to(() => Receipt(grocery: grocery));
  }

  void moveToPrescription(String id) async {
    DocumentSnapshot querySnapshot = await MedicalApi.medicalRef.doc(id).get();
    MedicalModel medical = MedicalModel.fromJson(querySnapshot.data()! as Map<String, dynamic>);

    Get.to(() => Prescription(medical: medical));
  }
}
