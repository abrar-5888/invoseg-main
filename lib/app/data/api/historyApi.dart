import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/app/data/api/firebaseNodes.dart';
// ignore_for_file: file_names

class HistoryApi {
  HistoryApi._();
  static final historyRef = FirebaseFirestore.instance.collection(FirebaseNodes.USER_BUTTON_REQUEST);
  static final historyQuery = historyRef.orderBy("pressedTime", descending: true);
}
