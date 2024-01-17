import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

int notification_count = 0;
int gro_count = 0;
int med_count = 0;
int history_count = 0;
int plot_count = 0;
int feed_count = 0;
String logo = "";
bool isLoading = false;
FirebaseApp secondApp = Firebase.app('CMS-All');
FirebaseApp firstApp = Firebase.app('Usman');

Future<void> getLogo() async {
  isLoading = true;
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instanceFor(app: firstApp)
          .collection('Logo')
          .limit(1)
          .get();
  DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
  final data = documentSnapshot.data() as Map<String, dynamic>;
  print(data['logoId']);
  logo = data['logoId'];
  isLoading = false;
}

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

Future<void> addCount() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('counts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    var doc = querySnapshot.docs;
    var length = doc.length;
    print(
        "length++++++++++++++++++++++++++++++++++++++++++++++++++++{{{{{{{{{{{{{{{{{{{{{{{{$length}}}}}}}}}}}}}}}}}}}}}}}}");
    if (length <= 0) {
      await FirebaseFirestore.instance.collection('counts').add({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'tabs': 0,
        'mainIcons': 0,
        'trendingProperties': 0,
        'notificationIconPress': 0,
        'button-one': 0,
        'button-two': 0,
        'button-three': 0,
        'editButton': 0,
        'viewProfile': 0,
        'addAfamilyM': 0,
        'residentIdCount': 0,
      });
    } else {
      print('Already Created');
    }
  } catch (e) {
    print(e);
  }
}

Future<void> updateEditButton() async {
  try {
    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection('counts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    var id = doc.docs.first.id;
    var data = doc.docs.first;
    print(data['editButton']);
    print(id);
    await FirebaseFirestore.instance.collection('counts').doc(id).update({
      'editButton': data['editButton'] + 1,
    });
  } catch (e) {
    print(e);
  }
}

Future<void> updateMainIcons() async {
  try {
    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection('counts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    var id = doc.docs.first.id;
    var data = doc.docs.first;
    print(data['mainIcons']);
    print(id);
    await FirebaseFirestore.instance.collection('counts').doc(id).update({
      'mainIcons': data['mainIcons'] + 1,
    });
  } catch (e) {
    print(e);
  }
}

Future<void> updateResidentIdCount() async {
  try {
    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection('counts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    var id = doc.docs.first.id;
    var data = doc.docs.first;
    print(data['residentIdCount']);
    print(id);
    await FirebaseFirestore.instance.collection('counts').doc(id).update({
      'residentIdCount': data['residentIdCount'] + 1,
    });
  } catch (e) {
    print(e);
  }
}

Future<void> updateAddFM() async {
  try {
    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection('counts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    var id = doc.docs.first.id;
    var data = doc.docs.first;
    print(data['addAfamilyM']);
    print(id);
    await FirebaseFirestore.instance.collection('counts').doc(id).update({
      'addAfamilyM': data['addAfamilyM'] + 1,
    });
  } catch (e) {
    print(e);
  }
}

Future<void> updateViewProf() async {
  try {
    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection('counts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    var id = doc.docs.first.id;
    var data = doc.docs.first;
    print(data['viewProfile']);
    print(id);
    await FirebaseFirestore.instance.collection('counts').doc(id).update({
      'viewProfile': data['viewProfile'] + 1,
    });
  } catch (e) {
    print(e);
  }
}

Future<void> updateNoti() async {
  try {
    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection('counts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    var id = doc.docs.first.id;
    var data = doc.docs.first;
    print(data['notificationIconPress']);
    print(id);
    await FirebaseFirestore.instance.collection('counts').doc(id).update({
      'notificationIconPress': data['notificationIconPress'] + 1,
    });
  } catch (e) {
    print(e);
  }
}

Future<void> updateButtonTwo() async {
  try {
    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection('counts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    var id = doc.docs.first.id;
    var data = doc.docs.first;
    print(data['button-two']);
    print(id);
    await FirebaseFirestore.instance.collection('counts').doc(id).update({
      'button-two': data['button-two'] + 1,
    });
  } catch (e) {
    print(e);
  }
}

Future<void> updateButtonThree() async {
  try {
    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection('counts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    var id = doc.docs.first.id;
    var data = doc.docs.first;
    print(data['button-three']);
    print(id);
    await FirebaseFirestore.instance.collection('counts').doc(id).update({
      'button-three': data['button-three'] + 1,
    });
  } catch (e) {
    print(e);
  }
}

Future<void> updateButtonOne() async {
  try {
    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection('counts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    var id = doc.docs.first.id;
    var data = doc.docs.first;
    print(data['button-one']);
    print(id);
    await FirebaseFirestore.instance.collection('counts').doc(id).update({
      'button-one': data['button-one'] + 1,
    });
  } catch (e) {
    print(e);
  }
}

Future<void> updateTabs() async {
  try {
    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection('counts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    var id = doc.docs.first.id;
    var data = doc.docs.first;
    print(data['tabs']);
    print(id);
    await FirebaseFirestore.instance.collection('counts').doc(id).update({
      'tabs': data['tabs'] + 1,
    });
  } catch (e) {
    print(e);
  }
}

Future<void> updateTrendingP() async {
  try {
    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection('counts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    var id = doc.docs.first.id;
    var data = doc.docs.first;
    print(data['trendingProperties']);
    print(id);
    await FirebaseFirestore.instance.collection('counts').doc(id).update({
      'trendingProperties': data['trendingProperties'] + 1,
    });
  } catch (e) {
    print(e);
  }
}
