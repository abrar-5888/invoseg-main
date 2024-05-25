// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/data/api/firebaseNodes.dart';

class PlotsAPI {
  PlotsAPI._();
  static final plotsRef = FirebaseFirestore.instance.collection(FirebaseNodes.PLOTS);
  static final plotsQuery = plotsRef.orderBy("timestamp");
}
