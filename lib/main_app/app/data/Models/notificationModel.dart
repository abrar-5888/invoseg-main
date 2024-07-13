import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String description;
  final String image;
  final bool isRead;
  final String title;
  final String uid;
  final String id;
  final int pressedTime;
  final String time;
  final String date;

  NotificationModel({
    required this.description,
    required this.image,
    required this.isRead,
    required this.title,
    required this.uid,
    required this.id,
    required this.pressedTime,
    required this.time,
    required this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      description: json['description'],
      image: json['image'],
      isRead: json['isRead'],
      title: json['title'],
      uid: json['uid'],
      id: json['id'],
      pressedTime: (json['pressedTime'] as Timestamp).millisecondsSinceEpoch,
      time: json['time'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'image': image,
      'isRead': isRead,
      'title': title,
      'uid': uid,
      'id': id,
      'pressedTime': pressedTime,
      'time': time,
      'date': date,
    };
  }
}
