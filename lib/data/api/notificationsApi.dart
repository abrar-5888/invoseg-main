import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/data/api/firebaseNodes.dart';
// ignore_for_file: file_names

class NotificationsApi {
  NotificationsApi._();
  static final notificationsRef = FirebaseFirestore.instance.collection(FirebaseNodes.NOTIFICATIONS);
  static final notificationQuery = notificationsRef.orderBy("pressedTime");

  static Future<void> updateIsRead() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await notificationQuery.where('isRead', isEqualTo: false).get();

    for (DocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  static Future<void> updateIsReadGrocery() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await notificationQuery.where('isRead', isEqualTo: false).where('title', isEqualTo: 'GROCERY').get();

    for (DocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  static Future<void> updateIsReadMedical() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await notificationQuery.where('isRead', isEqualTo: false).where('title', isEqualTo: 'MEDICAL').get();

    for (DocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      await doc.reference.update({'isRead': true});
    }
  }
}
