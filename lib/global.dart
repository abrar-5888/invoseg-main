import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

int notification_count = 0;
int gro_count = 0;
int med_count = 0;
int history_count = 0;
int plot_count = 0;
int feed_count = 0;

Future<List<bool>> getAllIsReadStatus() async {
  List<bool> isReadList = [];
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      final data = documentSnapshot.data() as Map<String, dynamic>;
      final isRead = data['isRead'] ?? false;
      final des = data['description'];
      if (des.toString().contains("Order") && isRead == false) {
        gro_count = gro_count + 1;
      }
      if ((des.toString()).contains("Prescription") ||
          (des.toString()).contains("generated") && isRead == false) {
        med_count = med_count + 1;
      }

      isReadList.add(isRead);
    }
    print("ISREAD ++ ${isReadList}");
    notification_count = isReadList.length;
    print("noti count== ${notification_count}");
  } catch (e) {
    print('Error fetching isRead status: $e');
    // Handle errors gracefully
  }
  return isReadList;
}

Future<void> updateAllIsReadStatus(bool isRead) async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('notifications').get();
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      batch.update(documentSnapshot.reference, {'isRead': isRead});
    }

    await batch.commit();
  } catch (e) {
    print('Error updating isRead status for all documents: $e');
    // Handle errors gracefully
  }
}
