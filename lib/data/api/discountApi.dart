// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/data/api/firebaseNodes.dart';

class DiscountsApi {
  DiscountsApi._();
  static final discountsRef = FirebaseFirestore.instance.collection(FirebaseNodes.DISCOUNTS);
  static final discountsQuery = discountsRef
      // .orderBy("timestamp")
      ;
}
