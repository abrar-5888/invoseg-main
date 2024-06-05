import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: file_names

class HistoryModel {
  final String type;
  final String uid;
  final int pressedTime;

  HistoryModel({required this.type, required this.uid, required this.pressedTime});

  factory HistoryModel.fromJson(Map<String, dynamic> data) {
    return HistoryModel(
      type: data['type'],
      uid: data['uid'],
      pressedTime: (data['pressedTime'] as Timestamp).millisecondsSinceEpoch,
    );
  }
}
