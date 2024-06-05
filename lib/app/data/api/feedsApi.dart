import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/app/data/api/firebaseNodes.dart';
// ignore_for_file: file_names

class FeedsApi {
  FeedsApi._();
  static final feedsRef = FirebaseFirestore.instance.collection(FirebaseNodes.FEED);
  static final feedsQuery = feedsRef
      // .orderBy("timestamp")
      ;

  static Future<void> updateLikes(String docId, Map<String, dynamic> data) async {
    await feedsRef.doc(docId).update(data);
  }
}
