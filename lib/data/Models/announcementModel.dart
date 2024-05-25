// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementModel {
  final String id;
  final String date;
  final String description;
  final String logo;
  final String imgUrl;
  final int pressedTime;
  final List<String> seenUids;
  final String societyName;
  final String time;
  final String title;

  AnnouncementModel({
    required this.imgUrl,
    required this.id,
    required this.date,
    required this.description,
    required this.logo,
    required this.pressedTime,
    required this.seenUids,
    required this.societyName,
    required this.time,
    required this.title,
  });

  factory AnnouncementModel.fromJson(String id, Map<String, dynamic> json) {
    return AnnouncementModel(
      id: id,
      imgUrl: json['imgUrl'],
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'] ?? '',
      pressedTime: (json['pressedTime'] as Timestamp).millisecondsSinceEpoch,
      seenUids: List<String>.from(json['seenUids'] ?? []),
      societyName: json['societyName'] ?? '',
      time: json['time'] ?? '',
      title: json['title'] ?? '',
    );
  }
}
