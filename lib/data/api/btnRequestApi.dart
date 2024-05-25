// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/data/Models/sendRequestModel.dart';

class ButtonRequestAPI {
  ButtonRequestAPI._();

  Future<void> sendRequest(SendRequestModel request, String collectionName) async {
    final requestRef = FirebaseFirestore.instance.collection(collectionName);

    var key = requestRef.doc().id;
    await requestRef.doc(key).set(request.toJson());
  }
}
