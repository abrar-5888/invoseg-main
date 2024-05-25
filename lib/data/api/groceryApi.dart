// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/data/api/firebaseNodes.dart';

class GroceryApi {
  GroceryApi._();
  static final groceryRef = FirebaseFirestore.instance.collection(FirebaseNodes.GROCERY);
  static final groceryQuery = groceryRef.orderBy("timestamp");
}
