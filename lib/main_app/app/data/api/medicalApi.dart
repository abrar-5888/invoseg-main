// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/main_app/app/data/api/firebaseNodes.dart';

class MedicalApi {
  MedicalApi._();
  static final medicalRef = FirebaseFirestore.instance.collection(FirebaseNodes.MEDICAL);
  static final medicalQuery = medicalRef.orderBy("timestamp");
}
