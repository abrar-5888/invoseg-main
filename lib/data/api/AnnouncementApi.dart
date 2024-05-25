// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/data/api/firebaseNodes.dart';

class AnnouncementsApi {
  AnnouncementsApi._();
  static final announcementsRef = FirebaseFirestore.instance.collection(FirebaseNodes.ANNOUNCEMENT);
  static final announcementsQuery = announcementsRef
      // .orderBy("timestamp")
      ;

  static void updateAnnouncement(String docId, String uid) {
    announcementsRef.doc(docId).update({
      'seenUids': FieldValue.arrayUnion([uid])
    });
  }
}
