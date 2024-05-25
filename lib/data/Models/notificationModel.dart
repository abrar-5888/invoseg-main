import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: file_names


class NotificationModel {
  final String date;
  final String description;
  final String id;
  final String image;
  final String societyName;
  final bool isRead;
  final Timestamp pressedTime;
  final String time;
  final String title;
  final String uid;

  NotificationModel({
    required this.date,
    required this.description,
    required this.id,
    required this.image,
    required this.societyName,
    required this.isRead,
    required this.pressedTime,
    required this.time,
    required this.title,
    required this.uid,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> data) {
    return NotificationModel(
      date: data['date'] ?? '',
      description: data['description'] ?? '',
      id: data['id'] ?? '',
      image: data['image'] ?? '',
      societyName: data['societyName'] ?? '',
      isRead: data['isRead'] ?? false,
      pressedTime: data['pressedTime'] ?? DateTime.now(),
      time: data['time'] ?? '',
      title: data['title'] ?? '',
      uid: data['uid'] ?? '',
    );
  }
}
