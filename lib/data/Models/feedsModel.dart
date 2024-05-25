import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: file_names

class FeedsModel {
  final String date;
  final String description;
  final String id;
  final int likes;
  final String time;
  final List<String> mediaUrls;
  final List<dynamic> likeUids;
  final String logo;
  final int timestamp;
  final String title;

  FeedsModel({
    required this.date,
    required this.description,
    required this.id,
    required this.likes,
    required this.time,
    required this.mediaUrls,
    required this.likeUids,
    required this.logo,
    required this.timestamp,
    required this.title,
  });

  factory FeedsModel.fromJson(Map<String, dynamic> data) {
    return FeedsModel(
      date: data['date'] ?? "",
      description: data['description'] ?? "",
      id: data['id'] ?? "",
      likes: data['likes'] ?? 0,
      time: data['time'] ?? "",
      mediaUrls: List<String>.from(data['mediaUrls'] ?? []),
      likeUids: List<dynamic>.from(data['Likesuids'] ?? []),
      logo: data['logo'] ?? "",
      timestamp: (data['timestamp'] as Timestamp).millisecondsSinceEpoch,
      title: data['title'] ?? "",
    );
  }
}
