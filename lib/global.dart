import 'package:cloud_firestore/cloud_firestore.dart';

int notification_count = 0;
int gro_count = 0;
int med_count = 0;
int history_count = 0;
int plot_count = 0;
int feed_count = 0;

Future<List<bool>> getAllIsReadStatus() async {
  List<bool> isReadList = [];
  List<bool> groList = [];
  List<bool> medList = [];
  // List<bool> isReadList = [];
  // List<bool> isReadList = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      final data = documentSnapshot.data() as Map<String, dynamic>;
      final isRead = data['isRead'] ?? false;

      isReadList.add(isRead);
      // if (isRead == false && data['description'].toString().contains("Order")) {
      //   gro_count = gro_count + 1;
      // } else if (isRead == false &&
      //     data['description'].toString().contains("Meet ID")) {
      //   med_count = med_count + 1;
      // }
    }

    notification_count = isReadList.length;

    QuerySnapshot med = await FirebaseFirestore.instance
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .where('title', isEqualTo: 'DOCTOR')
        .get();

    for (QueryDocumentSnapshot documentSnapshot in med.docs) {
      final data = documentSnapshot.data() as Map<String, dynamic>;
      final isRead = data['isRead'] ?? false;

      medList.add(isRead);
      // if (isRead == false && data['description'].toString().contains("Order")) {
      //   gro_count = gro_count + 1;
      // } else if (isRead == false &&
      //     data['description'].toString().contains("Meet ID")) {
      //   med_count = med_count + 1;
      // }
    }

    med_count = medList.length;
    QuerySnapshot gro = await FirebaseFirestore.instance
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .where('title', isEqualTo: 'GROCERY')
        .get();

    for (QueryDocumentSnapshot documentSnapshot in gro.docs) {
      final data = documentSnapshot.data() as Map<String, dynamic>;
      final isRead = data['isRead'] ?? false;

      groList.add(isRead);
      // if (isRead == false && data['description'].toString().contains("Order")) {
      //   gro_count = gro_count + 1;
      // } else if (isRead == false &&
      //     data['description'].toString().contains("Meet ID")) {
      //   med_count = med_count + 1;
      // }
    }

    gro_count = groList.length;

    // Notify listeners about the change
  } catch (e) {
    print('Error fetching isRead status: $e');
  }
  return isReadList;
}

void resetNotificationCount() {
  notification_count = 0;
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
  }
}

Future<void> updateGroisReadbool(bool isRead) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where("title", isEqualTo: 'GROCERY')
        .get();
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      batch.update(documentSnapshot.reference, {'isRead': isRead});
    }

    await batch.commit();
  } catch (e) {
    print('Error updating isRead status for all documents: $e');
  }
}

Future<void> updateMedisRead(bool isRead) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where("title", isEqualTo: "DOCTOR")
        .get();
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      batch.update(documentSnapshot.reference, {'isRead': isRead});
    }

    await batch.commit();
  } catch (e) {
    print('Error updating isRead status for all documents: $e');
  }
}
